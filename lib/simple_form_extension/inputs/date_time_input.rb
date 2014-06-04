module SimpleFormExtension
  module Inputs
    class DateTimeInput < SimpleForm::Inputs::DateTimeInput
      def input(wrapper_options = nil)
      	input_html_options[:class] << "form-control"
        "<div class=\"input-group\">
          #{@builder.text_field(attribute_name, input_html_options)}
          <div class=\"input-group-addon btn-onclick-event\">
            <i class=\"fa fa-calendar\"></i>
          </div>
        </div> ".html_safe
      end
    end
  end
end
