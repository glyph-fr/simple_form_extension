module SimpleFormExtension
  module Inputs
    class ImageInput < SimpleForm::Inputs::Base
      include SimpleFormExtension::Translations
      include SimpleFormExtension::FileConcern

      delegate :content_tag, :image_tag, to: :template

      def input(wrapper_options = nil)
        input_html_options[:class] << "image-upload"
        input_html_options[:accept] ||= SimpleFormExtension.default_image_input_accept

        input_markup
      end

      private

      def input_markup
        content_tag(:div, class: 'fileinput fileinput-new', data: { provides: 'fileinput' }) do
          content_tag(:div) do
            content_tag(:div, class: 'btn btn-default btn-file') do
              content_tag(:div, _translate('image.select'), class: 'fileinput-new') +
              content_tag(:div, _translate('image.change'), class: 'fileinput-exists') +
              @builder.file_field(attribute_name, input_html_options)
            end +

            content_tag(:button, class: 'btn btn-danger fileinput-exists', type: 'button', data: { dismiss: 'fileinput' }) do
              content_tag(:i, '', class: 'fa fa-times')
            end
          end +

          existing_image_tag
        end
      end

      def existing_image_tag
        # If an existing paperclip image is found
        if file_exists?
          file_preview_and_remove_button
        else
          content_tag(:div, class: 'fileinput-preview thumbnail') do
            content_tag(:div, '', class: 'empty-thumbnail')
          end
        end
      end

      def image
        @image ||= object.try(attribute_name)
      end

      def file_preview_and_remove_button
        if image.variable? || image.previewable?
          container_style = 'position: relative; height: 100%; width: 100%; min-height: 50px;min-width: 58px; display: block;'

          content_tag(:div, class: 'fileinput-preview thumbnail') do
            content_tag(:div, style: container_style, data: { provides: 'existing-file' }) do
              image_tag(
                file_url,
                style: 'height: 100%; width: 100%; display: block;', data: { toggle: 'existing-file' }
              ) +
              remove_image_button
            end
          end
        else
          super
        end
      end

      # Returns the paperclip or active_storage attachment url to show in the
      # preview thumbnail
      #
      def file_url
        if paperclip_attachment_attached?
          object.send(attribute_name).url(image_style)
        elsif activestorage_attachment_attached?
          attachment = object.send(attribute_name)

          if attachment.representable?
            attachment.representation(resize: "400x150>")
          else
            attachment.service_url
          end
        end
      end

      def remove_image_button
        return unless object.respond_to?(:"#{ remove_attachment_method }=")

        button_style = 'position: absolute; top: 10px; left: 10px;'

        content_tag(:button, class: 'btn btn-danger', style: button_style, type: 'button', data: { dismiss: 'existing-file' }) do
          content_tag(:i, '', class: 'fa fa-remove', data: { :'removed-class' => 'fa fa-refresh' }) +
          @builder.hidden_field(remove_attachment_method, class: 'remove-file-input', value: nil)
        end
      end

      def image_style
        styles = object.send(attribute_name).styles.map(&:first)
        # Check if there's a :thumb or :thumbnail style in attachment definition
        thumb = styles.find { |s| %w(thumb thumbnail).include?(s.to_s) }
        # Return the potentially smallest size !
        thumb || styles.first || :original
      end
    end
  end
end
