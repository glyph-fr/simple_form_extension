# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :input_group_append, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'control-label'

    b.wrapper tag: 'div', class: "input-group" do |ba|
      ba.use :icon, wrap_with: { tag: 'span', class: 'input-group-addon' }
      ba.use :input, class: 'form-control'
    end
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :input_group_prepend, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'control-label'

    b.wrapper tag: 'div', class: "input-group" do |ba|
      ba.use :input, class: 'form-control'
      ba.use :icon, wrap_with: { tag: 'span', class: 'input-group-addon' }
    end
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :popover, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'control-label'

    b.wrapper tag: 'div', class: "input-group" do |ba|
      ba.use :input, class: 'form-control'
      ba.use :popover, wrap_with: { tag: 'span', class: 'input-group-addon' }
    end
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :label_popover, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder

    b.wrapper tag: 'div', class: 'label-wrapper' do |label|
      label.use :label, class: 'control-label'
      label.use :popover
    end

    b.wrapper tag: 'div' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  # Add default wrapper for date inputs if the simple_form_bootstrap initializer
  # has been generated
  #
  if config.wrappers.keys.include?('vertical_form')
    config.wrapper_mappings = {
      datetime: :vertical_form,
      date: :vertical_form,
      time: :vertical_form
    }
  end
end
