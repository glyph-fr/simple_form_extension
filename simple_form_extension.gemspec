lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'simple_form_extension/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_form_extension'
  spec.version       = SimpleFormExtension::VERSION
  spec.authors       = ['Glyph-fr']
  spec.email         = ['contact@glyph.fr']
  spec.summary       = 'This gems adds custom common input types to simple form.'
  spec.description   = 'The following custom Simple Form inputs are available : boolean, collection_check_boxes, collection_radio_buttons, color, date_time, file, image, numeric, selectize and slider'
  spec.homepage      = 'http://www.glyph.fr'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 3.1'
  spec.add_dependency 'simple_form'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
