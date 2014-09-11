module SimpleFormExtension
  module Components
    module Popovers
 
      def popover(wrapper_options)
        return nil unless options[:popover]

        options = { 
          class: 'btn-popover fa fa-question-circle',
          :rel => 'popover',
          :'data-toggle' => 'popover',
          :'data-container' => 'body',
          :'data-title' => popover_title,
          :'data-content' => popover_content,
          :'data-placement' => popover_position,
          :'data-trigger' => popover_tigger
        }
        
        template.content_tag(:i, '', options)
      end


      def popover_title
        popover_options[:title]
      end

      def popover_content
        popover_options[:content]
      end

      def popover_position
        popover_options[:position] ||= "auto"
      end

      def popover_tigger
        popover_options[:trigger] ||= "click"
      end

      private

      def popover_options
        options[:popover] ||= {}
      end
    end
  end
end
