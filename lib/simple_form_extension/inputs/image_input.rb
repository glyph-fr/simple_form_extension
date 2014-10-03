module SimpleFormExtension
  module Inputs
    class ImageInput < SimpleForm::Inputs::Base
      include SimpleFormExtension::Translations

      def input(wrapper_options = nil)
        input_html_options[:class] << "image-upload"

        "<div class=\"fileinput fileinput-new\" data-provides=\"fileinput\">
          <div class=\"\">
            <div class=\"btn btn-default btn-file\" type=\"button\">
              <span class=\"fileinput-new\">#{ _translate('image.select') }</span>
              <span class=\"fileinput-exists\">#{ _translate('image.change') }</span>
              #{@builder.file_field(attribute_name, input_html_options)}
            </div>
            <button class=\"btn btn-danger fileinput-exists pull-right\" data-dismiss=\"fileinput\" type=\"button\"><i class=\"fa fa-times\"></i></button>
          </div>
          <div class=\"fileinput-preview thumbnail\">
            #{ image_tag }
          </div>
        </div>".html_safe
      end

      private

      def image_tag
        if @builder.object.send(:"#{ attribute_name }?")
          image_url = @builder.object.send(attribute_name).url(image_style)
          "<img src=\"#{ image_url }\" style=\"height: 100%; width: 100%; display: block;\">"
        else
          "<img data-src='holder.js/100%x100%' alt=\"100%x100%\" src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxOTAiIGhlaWdodD0iMTQwIj48cmVjdCB3aWR0aD0iMTkwIiBoZWlnaHQ9IjE0MCIgZmlsbD0iI2VlZSI+PC9yZWN0Pjx0ZXh0IHRleHQtYW5jaG9yPSJtaWRkbGUiIHg9Ijk1IiB5PSI3MCIgc3R5bGU9ImZpbGw6I2FhYTtmb250LXdlaWdodDpib2xkO2ZvbnQtc2l6ZToxMnB4O2ZvbnQtZmFtaWx5OkFyaWFsLEhlbHZldGljYSxzYW5zLXNlcmlmO2RvbWluYW50LWJhc2VsaW5lOmNlbnRyYWwiPjE5MHgxNDA8L3RleHQ+PC9zdmc+\" style=\"height: 100%; width: 100%; display: block;\">"
        end
      end

      def image_style
        styles = @builder.object.send(attribute_name).styles.map(&:first)
        # Check if there's a :thumb or :thumbnail style in attachment definition
        thumb = styles.find { |s| %w(thumb thumbnail).include?(s.to_s) }
        # Return the potentially smallest size !
        thumb || styles.first || :original
      end
    end
  end
end
