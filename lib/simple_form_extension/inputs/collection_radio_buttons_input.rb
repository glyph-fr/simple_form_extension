module SimpleFormExtension
  module Inputs
    class CollectionRadioButtonsInput < SimpleForm::Inputs::CollectionRadioButtonsInput
      protected

      def build_nested_boolean_style_item_tag(collection_builder)
      	"#{collection_builder.radio_button} <i class=\"radio-icon\"></i> #{collection_builder.text}".html_safe
      end

      def item_wrapper_class
      	nested_boolean_style? ? "radio" : "radio-inline"
      end
    end
  end
end
