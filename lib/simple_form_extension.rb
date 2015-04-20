require 'simple_form_extension/version'
require 'redactor-rails'
require 'underscore-rails'

module SimpleFormExtension
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Translations
    autoload :Components
    autoload :Inputs
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleFormExtension::Components::Icons)
SimpleForm::Inputs::Base.send(:include, SimpleFormExtension::Components::Popovers)

SimpleForm.custom_inputs_namespaces << 'SimpleFormExtension::Inputs'

require 'simple_form_extension/railtie' if defined?(Rails)