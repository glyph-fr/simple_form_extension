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

            content_tag(:button, class: 'btn btn-default fileinput-exists', type: 'button', data: { dismiss: 'fileinput' }) do
              content_tag(:i, '', class: 'fa fa-times')
            end
          end
        end +

        existing_file_tag
      end

      def existing_file_tag
        return '' unless has_file?

        url = object.send(attribute_name).url

        content_tag(:div, class: 'input-group help-block existing-file', data: { provides: 'existing-file'}) do
          content_tag(:span, class: 'input-group-addon') do
            "#{ _translate('file.existing_file') } : ".html_safe
          end +

          content_tag(:div, class: 'btn-group') do
            content_tag(:a, class: 'btn btn-default ', href: url, target: '_blank', data: { toggle: 'existing-file' }) do
              content_tag(:i, '', class: 'fa fa-file') +
              "&nbsp;".html_safe +
              object.send(:"#{ attribute_name }_file_name").html_safe
            end +

            remove_file_button
          end
        end
      end

      def remove_file_button
        return unless object.respond_to?(:"#{ remove_attachment_method }=")

        content_tag(:button, class: 'btn btn-default', type: 'button', data: { dismiss: 'existing-file' }) do
          content_tag(:i, '', class: 'fa fa-remove', data: { :'removed-class' => 'fa fa-refresh' }) +
          @builder.hidden_field(remove_attachment_method, class: 'remove-file-input', value: nil)
        end
      end

      def remove_attachment_method
        options[:remove_method] || :"remove_#{ attribute_name }"
      end

      def has_file?
        @has_file ||= object.send(:"#{ attribute_name }?")
      end
    end
  end
end
