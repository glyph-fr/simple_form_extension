var ExistingFileField;

ExistingFileField = class ExistingFileField {
  constructor($field1) {
    this.$field = $field1;
    this.$existingFile = this.$field.find('[data-toggle="existing-file"]');
    this.$removeButton = this.$field.find('[data-dismiss="existing-file"]');
    this.$removeInput = this.$removeButton.find('input');
    this.$removeButtonIcon = this.$removeButton.find('i');
    this.originalClass = this.$removeButtonIcon.attr('class');
    this.removedClass = this.$removeButtonIcon.attr('data-removed-class');
    this.$removeButton.on('click', $.proxy(this.removeButtonClicked, this));
  }

  removeButtonClicked() {
    if (this.$removeInput.val()) {
      return this.unsetRemoved();
    } else {
      return this.setRemoved();
    }
  }

  setRemoved() {
    this.$removeInput.val('1');
    this.$existingFile.hide(0);
    return this.$removeButtonIcon.attr({
      class: this.removedClass
    });
  }

  unsetRemoved() {
    this.$removeInput.removeAttr('value');
    this.$existingFile.show(0);
    return this.$removeButtonIcon.attr({
      class: this.originalClass
    });
  }

};

$.simpleForm.onDomReady(function($document) {
  // Plugin initialization delegated to body, so we do not need to run the
  // initialization process when the body has not changed
  if (!$document.is('body')) {
    return;
  }
  return $('body').on('click', '[data-dismiss="existing-file"]', function(e) {
    var $button, $field, data;
    $button = $(e.currentTarget);
    $field = $button.closest('[data-provides="existing-file"]');
    if (!$field.data('simple-form:existing-file')) {
      data = new ExistingFileField($field);
      data.removeButtonClicked();
      return $field.data('simple-form:existing-file', data);
    }
  });
});
