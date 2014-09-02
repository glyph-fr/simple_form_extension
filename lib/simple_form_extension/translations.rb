module SimpleFormExtension
  module Translations
    def translate(key, options = {})
      I18n.translate(['simple_form.extension', key].join('.'))
    end
  end
end
