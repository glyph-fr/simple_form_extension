class NumericInput < SimpleForm::Inputs::Base

  def input(wrapper_options = nil)
    input_html_options[:class] << "spinner-input form-control"
    if options.fetch(:spinner, true)
      "<div class=\"input-group spinner\">
        #{@builder.text_field(attribute_name, input_html_options)}
        <span class=\"input-group-btn\">
          <span class=\"spinner-buttons btn-group-vertical\">
            <button class=\"btn btn-default spinner-up\" type=\"button\" tabindex=\"-1\">
              <i class=\"fa fa-chevron-up\"></i>
            </button>
            <button class=\"btn btn-default spinner-down\" type=\"button\" tabindex=\"-1\">
              <i class=\"fa fa-chevron-down\"></i>
            </button>
          </span>
        </span>
      </div> ".html_safe
    else
      @builder.number_field(attribute_name, input_html_options)
    end
  end
  
end
