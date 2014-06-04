require "simple_form_extension/version"

module SimpleFormExtension
  extend ActiveSupport::Autoload

  autoload :Components
  autoload :Inputs
end

require "simple_form_extension/ext/form_builder"