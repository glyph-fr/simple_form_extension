var ColorPicker;

ColorPicker = class ColorPicker {
  constructor($el) {
    var $parent;
    this.$el = $el;
    if (($parent = this.$el.closest('[data-colorpicker-wrapper]')).length) {
      $parent.colorpicker();
    } else {
      this.$el.colorpicker();
    }
  }

};

$.fn.simpleFormColorpicker = function() {
  return this.each(function(i, el) {
    var $input, instance;
    $input = $(el);
    if ($input.data('simple-form:colorpicker')) {
      return;
    }
    instance = new ColorPicker($input);
    return $input.data('simple-form:colorpicker', instance);
  });
};

$.simpleForm.onDomReady(function($document) {
  return $document.find('[data-colorpicker]').simpleFormColorpicker();
});
