module SimpleFormExtension
  module Inputs
    class DateTimeInput < SimpleForm::Inputs::DateTimeInput
      include SimpleFormExtension::Translations

      def input(wrapper_options = nil)
      	input_html_options[:class] << "form-control"

        input_html_options[:data] ||= {}
        input_html_options[:data].merge!(
          :'date-format' => _translate('date.format'),
          :'datetime-format' => _translate('datetime.format'),
          :'week-start-day' => _translate('shared.week_start_day')
        )

        "<div class=\"input-group\">
          #{@builder.text_field(attribute_name, input_html_options)}
          <span class=\"input-group-btn\">
            <button type=\"button\" class=\"btn btn-default datetimepicker-trigger\">
              <i class=\"fa fa-calendar\"></i>
            </button>
          </span>
        </div> ".html_safe
      end
    end
  end
end
