module SimpleFormExtension
  module Inputs
    class ColorInput < SimpleForm::Inputs::Base
      delegate :content_tag, to: :template

      def input(wrapper_options = nil)
        input_html_options[:class] << "colorpicker form-control"

        input_html_options[:data] ||= {}
        input_html_options[:data].merge!(
          colorpicker: true,
          format: format,
          align: align
        )

        # Fetch value
        color = object.send(attribute_name)

        content_tag(:div, class: 'input-group color', data: { :'colorpicker-wrapper' => true }) do
          @builder.text_field(attribute_name, input_html_options) +

          content_tag(:span, class: 'input-group-addon') do
            content_tag(:i, '')
          end
        end
      end

      def format
        options[:format].presence || :hex
      end

      def align
        options[:align].presence || :right
      end
    end
  end
end
