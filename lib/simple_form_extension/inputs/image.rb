class ImageInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
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
      <div class=\"fileinput-preview thumbnail\"></div>
    </div>".html_safe
  end
end


