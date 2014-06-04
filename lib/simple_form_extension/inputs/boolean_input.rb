module SimpleFormExtension
  module Inputs
    class BooleanInput < SimpleForm::Inputs::BooleanInput
      def input(wrapper_options = nil)
        input_html_options[:class] << "check_boxes"
        super
      end

      private

      def build_check_box(unchecked_value, options)
        "#{@builder.check_box(attribute_name, input_html_options, checked_value, unchecked_value)} <i class=\"checkbox-icon\"></i>".html_safe
      end
    end
  end
end