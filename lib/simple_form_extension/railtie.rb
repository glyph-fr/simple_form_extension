module SimpleFormExtension
  class Railtie < Rails::Railtie
    initializer 'add vendor path to assets pipeline' do |app|
      %w(javascripts stylesheets images).each do |folder|
        app.config.assets.paths << vendor_asset_path_for(folder)
      end
    end

    initializer 'add images to precompile hook' do |app|
      Dir[vendor_asset_path_for('images/**/*.*')].each do |image_path|
        app.config.assets.precompile << image_path.split('/images/').pop
      end
    end

    private

    def vendor_asset_path_for(sub_path)
      File.expand_path("../../../vendor/assets/#{ sub_path }", __FILE__)
    end
  end
end
