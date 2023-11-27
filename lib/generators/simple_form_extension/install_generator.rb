module SimpleFormExtension
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Copy SimpleFormExtension files'
      source_root File.expand_path('templates', __dir__)

      def copy_config
        template 'config/initializers/simple_form_extension.rb'
      end

      def copy_locales
        template 'config/locales/simple_form_extension.en.yml'
        template 'config/locales/simple_form_extension.fr.yml'
      end

      def bundle
        Bundler.with_clean_env do
          run 'bundle install'
        end
      end
    end
  end
end
