# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'simple_form_extension/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_form_extension'
  spec.version       = SimpleFormExtension::VERSION
  spec.authors       = ['Alexandre Vasseur']
  spec.email         = ['alex@glyph.fr']
  spec.summary       = %q{A simple extention for simple_form with, colorpiker, icon, fileupload, image upload}
  spec.description   = %q{A simple extention for simple_form with, colorpiker, icon, fileupload, image upload}
  spec.homepage      = 'http://www.glyph.fr'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 3.1'
  spec.add_dependency 'simple_form'
  spec.add_dependency 'redactor-rails'
  spec.add_dependency 'selectize-rails'
  spec.add_dependency 'compass-rails'
  spec.add_dependency 'underscore-rails'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
