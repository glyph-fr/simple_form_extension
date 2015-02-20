module SimpleFormExtension
  module Inputs
    class DateTimeInput < SimpleForm::Inputs::DateTimeInput
      include SimpleFormExtension::Translations

      delegate :content_tag, to: :template

      def input(wrapper_options = nil)
      	input_html_options[:class] << "form-control"

        input_html_options[:data] ||= {}
        input_html_options[:data].merge!(
          :'date-format' => _translate('date.format.js'),
          :'datetime-format' => _translate('datetime.format.js'),
          :'week-start-day' => _translate('shared.week_start_day')
        )

        if (value = object.send(attribute_name)) && !input_html_options.key?(:value)
          format = _translate("#{ input_type }.format.rails")
          input_html_options[:value] = I18n.l(value, format: format)
        end


        content_tag(:div, class: 'input-group') do
          @builder.text_field(attribute_name, input_html_options) +

          content_tag(:span, class: 'input-group-btn') do
            content_tag(:button, type: 'button', class: 'btn btn-default datetimepicker-trigger') do
              content_tag(:i, '', class: 'fa fa-calendar')
            end
          end
        end
      end
    end
  end
end
