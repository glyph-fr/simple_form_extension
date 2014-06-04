module SimpleFormExtension
  module Inputs
    class CollectionCheckBoxesInput < SimpleForm::Inputs::CollectionCheckBoxesInput
      protected

      def build_nested_boolean_style_item_tag(collection_builder)
        "#{collection_builder.check_box} <i class=\"checkbox-icon\"></i> #{collection_builder.text}".html_safe
      end

      def item_wrapper_class
        nested_boolean_style? ? "checkbox" : "checkbox-inline"
      end
    end
  end
end
