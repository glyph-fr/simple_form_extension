var Spinbox;

Spinbox = class Spinbox {
  constructor($el) {
    var defaults, options;
    this.$el = $el;
    options = this.$el.find('input').data('spinner');
    defaults = {
      max: Number.POSITIVE_INFINITY
    };
    this.$el.spinbox($.extend(defaults, options));
  }

};

$.fn.simpleFormSpinbox = function() {
  return this.each(function(i, el) {
    var $input, instance;
    $input = $(el);
    if ($input.data('simple-form:spinbox')) {
      return;
    }
    instance = new Spinbox($input);
    return $input.data('simple-form:spinbox', instance);
  });
};

$.simpleForm.onDomReady(function($document) {
  var $spinbox;
  $spinbox = $document.find('.spinbox');
  if (!$spinbox.length) {
    return;
  }
  return $spinbox.simpleFormSpinbox();
});
