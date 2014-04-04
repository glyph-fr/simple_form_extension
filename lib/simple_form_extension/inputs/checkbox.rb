class BooleanInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    if nested_boolean_style?
      "<div class=\"checkbox\">
        #{@builder.check_box(attribute_name, input_html_options, checked_value, unchecked_value)}
      </div>".html_safe
    else
      "<div class=\"checkbox\">
        #{@builder.check_box(attribute_name, input_html_options, checked_value, unchecked_value)}
      </div>".html_safe
    end
  end
end
