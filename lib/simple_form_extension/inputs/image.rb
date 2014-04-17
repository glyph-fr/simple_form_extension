class ImageInput < SimpleForm::Inputs::Base

  def input(wrapper_options = nil)
    input_html_options[:class] << "image-upload"

    "<div class=\"fileinput fileinput-new\" data-provides=\"fileinput\">
      <div class=\"\">
        <button class=\"btn btn-default btn-file\" type=\"button\">
          <span class=\"fileinput-new\">Select image</span>
          <span class=\"fileinput-exists\">Change</span>
          #{@builder.file_field(attribute_name, input_html_options)}
        </button>
        <button class=\"btn btn-danger fileinput-exists pull-right\" data-dismiss=\"fileinput\" type=\"button\"><i class=\"fa fa-times\"></i></button>
      </div>
      <div class=\"fileinput-preview thumbnail\">
        <img data-src='holder.js/100%x100%' alt=\"100%x100%\" src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxOTAiIGhlaWdodD0iMTQwIj48cmVjdCB3aWR0aD0iMTkwIiBoZWlnaHQ9IjE0MCIgZmlsbD0iI2VlZSI+PC9yZWN0Pjx0ZXh0IHRleHQtYW5jaG9yPSJtaWRkbGUiIHg9Ijk1IiB5PSI3MCIgc3R5bGU9ImZpbGw6I2FhYTtmb250LXdlaWdodDpib2xkO2ZvbnQtc2l6ZToxMnB4O2ZvbnQtZmFtaWx5OkFyaWFsLEhlbHZldGljYSxzYW5zLXNlcmlmO2RvbWluYW50LWJhc2VsaW5lOmNlbnRyYWwiPjE5MHgxNDA8L3RleHQ+PC9zdmc+\" style=\"height: 100%; width: 100%; display: block;\">
      </div>
    </div>".html_safe
  end

end
