module SimpleFormExtension
  module Inputs
    class PeriodPickerInput < SimpleForm::Inputs::DateTimeInput
      include SimpleFormExtension::Translations

      delegate :content_tag, to: :template

      def input(wrapper_options = nil)
        input_html_options[:class] << "form-control"

        input_html_options[:data] ||= {}
        input_html_options[:data].merge!(type_specific_option)

        if (value = object.send(attribute_name).presence) && !input_html_options.key?(:value)
          format = _translate("#{ input_type }.format.rails")
          input_html_options[:value] = I18n.l(value, format: format)
        end

        content_tag(:div, class: 'periodpicker-container', data: { :'periodpicker-container' => true }) do
          @builder.text_field(attribute_name, input_html_options) +
          @builder.hidden_field(options[:end_date_field], data: { :'end-date-field' => true })
        end
      end

      private

      def type_specific_option
        options = { format: _translate("#{ input_type }.format.js") }

        if input_type == :time
          options[:'period-time-picker'] = true
        else 
          options[:'period-date-picker'] = true
          options[:'week-start-day'] = _translate('shared.week_start_day')
          options[:'format-date'] = _translate('date.format.js')
        end

        options
      end

      def icon
        input_type == :time ? 'clock-o' : 'calendar'
      end
    end
  end
end
