module SimpleFormExtension
  class Railtie < Rails::Railtie
    initializer 'add vendor path to assets pipeline' do |app|
      %w(javascripts stylesheets).each do |folder|
        app.config.assets.paths << File.expand_path(
          "../../../vendor/assets/#{ folder }",
          __FILE__
        )
      end
    end
  end
end
