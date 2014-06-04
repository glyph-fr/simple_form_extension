require 'simple_form/form_builder'

module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    alias_method :_original_find_mapping, :find_mapping

    def find_mapping(input_type)
      camelized = if (klass = self.class.mappings[input_type])
        name = klass.name
        (name =~ /^SimpleForm::Inputs/) ? name.split("::").last : name
      else
        "#{ input_type.to_s.camelize }Input"
      end

      mapping = attempt_mapping(camelized, SimpleFormExtension::Inputs)
      return (discovery_cache[input_type] = mapping) if mapping
      _original_find_mapping(input_type)
    end
  end
end
