module SimpleFormExtension
  module ResourceNameHelper
    def resource_name_for(resource)
      SimpleFormExtension.resource_name_methods.each do |method_name|
        if (value = resource.try(method_name)) then return value end
      end
    end
  end
end
