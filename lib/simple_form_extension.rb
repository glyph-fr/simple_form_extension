require "simple_form_extension/version"

module SimpleFormExtension
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Components
    autoload :Inputs
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleFormExtension::Components::Icons)

require "simple_form_extension/ext/form_builder"