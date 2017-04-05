module SimpleFormExtension
  module Inputs
    extend ActiveSupport::Autoload

    autoload :DateTimeInput
    autoload :PeriodPickerInput
    autoload :BooleanInput
    autoload :NumericInput
    autoload :CollectionCheckBoxesInput
    autoload :CollectionRadioButtonsInput
    autoload :ColorInput
    autoload :FileInput
    autoload :ImageInput
    autoload :RedactorInput
    autoload :SelectizeInput
    autoload :SliderInput
  end
end
