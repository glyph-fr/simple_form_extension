module SimpleFormExtension
  module Inputs
    class SelectizeInput < SimpleForm::Inputs::Base
      include SimpleFormExtension::Translations

      # This field only allows local select options (serialized into JSON)
      # Searching for remote ones will be implemented later.
      #
      # Data attributes that may be useful :
      #
      #   :'search-url' => search_url,
      #   :'search-param' => search_param,
      #   :'preload' => preload,
      #
      def input(wrapper_options = {})
        @attribute_name = foreign_key if relation?

        input_html_options[:data] ||= {}

        input_html_options[:data].merge!(
          :'selectize'       => true,
          :'value'           => serialized_value,
          :'creatable'       => creatable?,
          :'multi'           => multi?,
          :'add-translation' => _translate('selectize.add'),
          :'collection'      => collection,
          :'max-items'       => max_items,
          :'sort-field'      => sort_field,
          :'search-url'      => search_url,
          :'search-param'    => search_param,
          :'escape'          => escape
        )

        @builder.hidden_field attribute_name, input_html_options
      end

      def search_param
        options[:search_param] ||= 'q'
      end

      def search_url
        options[:search_url]
      end

      def creatable?
        !!options[:creatable]
      end

      def escape
        options[:escape]
      end

      def multi?
        (options.key?(:multi) && !!options[:multi]) ||
          enumerable?(value)
      end

      def max_items
        options[:max_items]
      end

      def sort_field
        if (sort_field = options[:sort_field]).present?
          sort_field
        elsif enum?
          'position'
        else
          'text'
        end
      end

      def collection
        return if search_url

        if (collection = options[:collection])
          if enumerable?(collection)
            collection.map(&method(:serialize_option))
          else
            (object.send(collection) || []).map(&method(:serialize_option))
          end
        elsif relation?
          reflection.klass.all.map(&method(:serialize_option))
        elsif enum?
          enum_options
        else
          []
        end
      end

      def serialized_value
        return input_html_options[:data][:value] if input_html_options[:data][:value]

        if multi?
          if relation?
            value.map do |item|
              if (resource = relation.find { |resource| resource.id == item.to_i }) && (text = text_from(resource))
                serialize_value(item, text)
              else
                serialize_value(item)
              end
            end
          else
            value.map(&method(:serialize_value))
          end
        else
          if relation? && relation && (text = text_from(relation))
            serialize_value(value, text)
          else
            serialize_value(value)
          end
        end
      end

      def value
        @value ||= options_fetch(:value) { object.send(attribute_name) }
      end

      def serialize_value(value, text = nil)
        { text: (text || value), value: value }
      end

      private

      def serialize_option(option)
        if option.kind_of?(Hash) && option.key?(:text) && option.key?(:value)
          option
        elsif option.kind_of?(ActiveRecord::Base)
          { text: name_for(option), value: option.id }
        elsif !option.kind_of?(Hash)
          { text: option.to_s, value: option }
        else
          raise ArgumentError.new "The individual collection items should " \
            "either be single items or a hash with :text and :value fields"
        end
      end

      def options_fetch(key, &block)
        [options, input_html_options].each do |hash|
          return hash[key] if hash.key?(key)
        end

        # Return default block value or nil if no block was given
        block ? block.call : nil
      end

      # Check if the given target object is enumerable. Used internally to
      # check wether :collection or :value arguments are collections.
      #
      def enumerable?(target)
        target.class.include?(Enumerable) || ActiveRecord::Relation === target
      end

      def name_for(option)
        option.try(:name) || option.try(:title) || option.to_s
      end

      def relation
        @relation ||= object.send(reflection.name) if relation?
      end

      def relation?
        !!reflection
      end

      def reflection
        @reflection ||= if object_class.respond_to?(:reflect_on_association)
          object_class.reflect_on_association(attribute_name)
        end
      end

      def enum?
        object_class.defined_enums.key?(attribute_name.to_s)
      end

      def enum_options
        object_class.defined_enums[attribute_name.to_s].map do |key, value|
          path = [object.model_name.i18n_key, attribute_name, key].join('.')
          translation = ::I18n.t("activerecord.enums.#{ path }", default: '')

          { text: translation.presence || key, value: key, position: value }
        end
      end

      def foreign_key
        @foreign_key ||= case reflection.macro
        when :belongs_to then reflection.foreign_key
        when :has_one then :"#{ reflection.name }_id"
        when :has_many then :"#{ reflection.name.to_s.singularize }_ids"
        end
      end

      def text_from(resource)
        resource.try(:title) || resource.try(:name)
      end

      # Retrieve actual model class even when the form object is a proxy like
      # for Ransack::Search or ActiveRecord::Relation classes
      #
      def object_class
        @object_class ||= if ((object_class = object.class) < ActiveRecord::Base)
          object_class
        elsif (klass = object.try(:klass))
          klass
        else
          object_class
        end
      end
    end
  end
end
