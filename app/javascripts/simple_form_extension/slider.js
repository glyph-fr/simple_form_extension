var Slider;

Slider = class Slider {
  constructor($el) {
    var ref, value, values;
    this.$el = $el;
    value = (values = (ref = this.$el.data('slider-value')) != null ? ref.toString().split(',') : void 0) ? values.length <= 1 ? parseFloat(values[0], 10) : (function() {
      var j, len, results;
      results = [];
      for (j = 0, len = values.length; j < len; j++) {
        value = values[j];
        results.push(parseFloat(value, 10));
      }
      return results;
    })() : void 0;
    if (this.$el.bootstrapSlider) {
      this.$el.bootstrapSlider({
        value: value
      });
    } else {
      this.$el.slider({
        value: value
      });
    }
  }

};

$.fn.simpleFormSlider = function() {
  return this.each(function(i, el) {
    var $select, instance;
    $select = $(el);
    if ($select.data('simple-form:slider')) {
      return;
    }
    instance = new Slider($select);
    return $select.data('simple-form:slider', instance);
  });
};

$.simpleForm.onDomReady(function($document) {
  return $document.find('[data-simple-form-slider]').simpleFormSlider();
});
