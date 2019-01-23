module SimpleFormExtension
  module Inputs
    class FileInput < SimpleForm::Inputs::Base
      include SimpleFormExtension::Translations
      include SimpleFormExtension::FileConcern

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

            content_tag(:button, class: 'btn btn-default fileinput-exists', type: 'button', data: { dismiss: 'fileinput' }) do
              content_tag(:i, '', class: 'fa fa-times')
            end
          end
        end +

        existing_file_tag
      end
    end
  end
end
