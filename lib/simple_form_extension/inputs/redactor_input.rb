module SimpleFormExtension
  module Inputs
    class RedactorInput < SimpleForm::Inputs::TextInput
      def input(wrapper_options = nil)
        @additional_classes ||= additional_classes
        @additional_classes -= [input_type]

        input_html_options[:data] ||= {}
        input_html_options[:data][:redactor] = true

        input_html_options[:data][:'redactor-config'] = (
          options[:config] || {}
        ).to_json

        super
      end
    end
  end
end
