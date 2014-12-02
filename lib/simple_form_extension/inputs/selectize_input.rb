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
        input_html_options[:data] ||= {}

        input_html_options[:data].merge!(
          :'selectize' => true,
          :'value' => serialized_value,
          :'creatable' => creatable?,
          :'multi' => multi?,
          :'add-translation' => _translate('selectize.add'),
          :'collection' => collection
        )

        @builder.hidden_field attribute_name, input_html_options
      end

      def creatable?
        !!options[:creatable]
      end

      def multi?
        (options.key?(:multi) && !!options[:multi]) ||
          value.class.include?(Enumerable)
      end

      def collection
        if (collection = options[:collection])
          if collection.class.include?(Enumerable)
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
        @value ||= input_html_options[:value] || object.send(attribute_name)
      end

      private

      def serialize_option(option)
        if option.kind_of?(Hash) && options.key?(:text) && option.key?(:value)
          option
        elsif !option.kind_of?(Hash)
          { text: option.to_s, value: option }
        else
          raise ArgumentError.new "The individual collection items should " \
            "either be single items or a hash with :text and :value fields"
        end
      end
    end
  end
end
