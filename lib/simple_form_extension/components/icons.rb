module SimpleFormExtension
  module Components
    module Icons
      def icon(wrapper_options)
        icon_class unless options[:icon].nil?
      end

      def icon_class
        template.content_tag(:i, '', class: options[:icon])
      end
    end
  end
end
