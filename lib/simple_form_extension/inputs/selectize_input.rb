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
        @attribute_name = reflection.foreign_key if relation?
        puts "RELATION ? => #{ relation? } // #{ reflection.foreign_key }"
        input_html_options[:data] ||= {}

        input_html_options[:data].merge!(
          :'selectize' => true,
          :'value' => serialized_value,
          :'creatable' => creatable?,
          :'multi' => multi?,
          :'add-translation' => _translate('selectize.add'),
          :'collection' => collection,
          :'max-items' => max_items
        )

        @builder.hidden_field attribute_name, input_html_options
      end

      def creatable?
        !!options[:creatable]
      end

      def multi?
        (options.key?(:multi) && !!options[:multi]) ||
          enumerable?(value)
      end

      def max_items
        options[:max_items]
      end

      def collection
        if (collection = options[:collection])
          if enumerable?(collection)
            collection.map(&method(:serialize_option))
          else
            (object.send(collection) || []).map(&method(:serialize_option))
          end
        else
          []
        end
      end

      def serialized_value
        if multi?
          value.map do |item|
            { text: item, value: item }
          end
        else
          value && { text: value, value: value }
        end
      end

      def value
        @value ||= options_fetch(:value) { object.send(attribute_name) }
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

      def enumerable?(object)
        object.class.include?(Enumerable) || ActiveRecord::Relation === object
      end

      def name_for(option)
        option.try(:name) || options.try(:title) || option.to_s
      end

      def relation?
        !!reflection
      end

      def reflection
        @reflection ||= object.class.reflect_on_association(attribute_name)
      end
    end
  end
end
