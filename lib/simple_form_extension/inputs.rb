module SimpleFormExtension
  module Inputs
    extend ActiveSupport::Autoload

    autoload :DateTimeInput
    autoload :BooleanInput
    autoload :NumericInput
    autoload :CollectionCheckBoxesInput
    autoload :CollectionRadioButtonsInput
    autoload :ColorInput
    autoload :FileInput
    autoload :ImageInput
  end
end
