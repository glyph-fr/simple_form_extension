module SimpleFormExtension
  module Components
    module Popovers

      def icon(wrapper_options)
        icon_class unless options[:icon].nil?
      end

      def icon_class
        template.content_tag(:i, '', class: options[:icon])
      end

      def popover(wrapper_options)        
        input_html_options[:rel] ||= 'popover'
        input_html_options['data-toggle'] ||= 'popover'
        input_html_options['data-title'] ||= popover_title
        input_html_options['data-content'] ||= popover_content
        input_html_options['data-placement'] ||= popover_position
        input_html_options['data-trigger'] ||= popover_tigger
        nil
      end

      def popover_title
        popover = options[:popover]
        popover.is_a?(Array) ? popover[0] : nil
      end

      def popover_content
        popover = options[:popover]
        popover.is_a?(Array) ? popover[1] : nil
      end

      def popover_position
        popover = options[:popover]
        popover.is_a?(Array) ? popover[2] : "top"
      end

      def popover_tigger
        popover = options[:popover]
        popover.is_a?(Array) ? popover[3] : "click"
      end
      
    end
  end
end
