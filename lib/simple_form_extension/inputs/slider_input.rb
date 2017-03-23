module SimpleFormExtension
  module Inputs
    class SliderInput < SimpleForm::Inputs::Base
      def input(wrapper_options = nil)
        input_html_options[:class] << 'form-control'

        input_html_options[:data] ||= {}
        input_html_options[:data][:'simple-form-slider'] = true

        [:min, :max, :step, :orientation, :range, :value].each do |key|
          if options.key?(key)
            input_html_options[:data][:"slider-#{ key }"] = options[key]
          end
        end

        input_html_options[:data][:'slider-value'] ||= object.send(attribute_name)

        if options[:disabled]
          input_html_options[:data][:'slider-enabled'] = false
        end

        if options[:ticks]
          input_html_options[:data][:ticks] = options[:ticks].to_json
        end

        @builder.hidden_field(attribute_name, input_html_options)
      end
    end
  end
end
