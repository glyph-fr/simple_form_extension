module SimpleForm
  module Components
    module Icons
		  def icon(wrapper_options)
		    return icon_class unless options[:icon].nil?
		  end

		  def icon_class
		    icon_tag = template.content_tag(:i, '', class: options[:icon])
		  end
	  end
	end  
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Icons)