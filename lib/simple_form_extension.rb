require 'simple_form_extension/version'
require 'simple_form'

module SimpleFormExtension
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Translations
    autoload :ResourceNameHelper
    autoload :FileConcern
    autoload :Components
    autoload :Inputs
  end

  # Allows overriding which methods are used by the fields that try to fetch
  # the name of a resource to display it instead of calling #to_s
  #
  mattr_accessor :resource_name_methods
  @@resource_name_methods = %i[name title]

  mattr_accessor :default_image_input_accept
  @@default_image_input_accept = 'image/jpeg,image/png,image/gif'
end

SimpleForm::Inputs::Base.include SimpleFormExtension::Components::Icons
SimpleForm::Inputs::Base.include SimpleFormExtension::Components::Popovers

SimpleForm.custom_inputs_namespaces << 'SimpleFormExtension::Inputs'

require 'simple_form_extension/railtie' if defined?(Rails)
