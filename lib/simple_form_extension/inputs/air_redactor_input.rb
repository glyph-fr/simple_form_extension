module SimpleFormExtension
  module Inputs
    class AirRedactorInput < SimpleForm::Inputs::TextInput
      def input(wrapper_options = nil)
        @additional_classes ||= additional_classes
        @additional_classes -= [input_type]

        
        input_html_options[:"data-air-redactor"] = true

        super
      end
    end
  end
end
