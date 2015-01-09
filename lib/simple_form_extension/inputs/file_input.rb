module SimpleFormExtension
  module Inputs
    class FileInput < SimpleForm::Inputs::Base
      include SimpleFormExtension::Translations

      delegate :content_tag, to: :template

      def input(wrapper_options = nil)
      	input_html_options[:class] << "file-upload"

        input_markup
      end

      private

      def input_markup
        content_tag(:div, class: 'fileinput fileinput-new input-group', data: { provides: 'fileinput' }) do
          content_tag(:div, class: 'form-control uneditable-input', data: { trigger: 'fileinput' }) do
            content_tag(:i, '', class: 'fa fa-file fileinput-exists') +
            content_tag(:span, '', class: 'fileinput-filename')
          end +

          content_tag(:div, class: 'input-group-btn') do
            content_tag(:div, class: 'btn btn-default btn-file') do
               content_tag(:span, _translate('file.select'), class: 'fileinput-new') +
               content_tag(:span, _translate('file.change'), class: 'fileinput-exists') +
               @builder.file_field(attribute_name, input_html_options)
             end +

            content_tag(:button, class: 'btn btn-danger fileinput-exists', type: 'button', data: { dismiss: 'fileinput' }) do
              content_tag(:i, '', class: 'fa fa-times')
            end
          end
        end +

        existing_file_tag
      end

      def existing_file_tag
        return '' unless object.send(:"#{ attribute_name }?")

        url = object.send(attribute_name).url

        content_tag(:div, class: 'input-group help-block existing-file') do
          content_tag(:span, class: 'input-group-addon') do
            "#{ _translate('file.existing_file') } : ".html_safe
          end +

          content_tag(:a, class: 'btn btn-default ', href: url, target: '_blank') do
            content_tag(:i, '', class: 'fa fa-file') +
            "&nbsp;".html_safe +
            object.send(:"#{ attribute_name }_file_name").html_safe
          end
        end
      end
    end
  end
end
