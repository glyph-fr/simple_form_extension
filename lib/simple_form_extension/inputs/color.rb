class ColorInput < SimpleForm::Inputs::Base

  def input(wrapper_options = nil)
    input_html_options[:class] << "colorpicker"
    "<div class=\"input-group color\">
      #{@builder.text_field(attribute_name, input_html_options)}
      <span class=\"input-group-addon\">
        <i style=\"background-color: ;\"></i>
      </span>
    </div>".html_safe
  end
  
end
