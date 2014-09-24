module SimpleFormExtension
  module Inputs
    class FileInput < SimpleForm::Inputs::Base
      include SimpleFormExtension::Translations

      def input(wrapper_options = nil)
      	input_html_options[:class] << "file-upload"

        "<div class=\"fileinput fileinput-new input-group\" data-provides=\"fileinput\">
    	  <div class=\"form-control uneditable-input\" data-trigger=\"fileinput\">
    	    <i class=\"fa fa-file fileinput-exists\"></i>
    	    <span class=\"fileinput-filename\"></span>
    	  </div>
    	  <div class=\"input-group-btn\">
    	    <div class=\"btn btn-default btn-file\" type=\"button\">
    	      <span class=\"fileinput-new\">#{ _translate('file.select') }</span>
    	      <span class=\"fileinput-exists\">#{ _translate('file.change') }</span>
    	      #{@builder.file_field(attribute_name, input_html_options)}
    	    </div>
    	    <button class=\"btn btn-danger fileinput-exists\" data-dismiss=\"fileinput\" type=\"button\"><i class=\"fa fa-times\"></i></button>
    	  </div>
    	</div>".html_safe
      end
    end
  end
end
