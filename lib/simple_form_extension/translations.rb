module SimpleFormExtension
  module Translations
    def _translate(key, options = {})
      I18n.translate(['simple_form.extension', key].join('.'))
    end
  end
end
