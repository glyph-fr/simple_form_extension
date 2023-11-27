var DatePicker, DateTimePicker, DateTimePickerBase, TimePicker;

DateTimePickerBase = class DateTimePickerBase {
  static forInput($input, type) {
    var picker;
    if ((picker = $input.data('simple-form-extension-datetimepicker'))) {
      return picker;
    } else {
      return new type($input);
    }
  }

  constructor($input1) {
    this.$input = $input1;
    this.locale = $('html').attr('lang') || 'en';
    $.datetimepicker.setLocale(this.locale);
    this.$input.data('simple-form-extension-datetimepicker', this);
    this.initializePicker();
  }

  initializePicker() {
    return this.$input.datetimepicker(this.processOptions());
  }

  processOptions() {
    return $.extend({}, this.defaultOptions(), this.options());
  }

  options() {
    return {};
  }

  defaultOptions() {
    return {
      lang: this.locale,
      format: this.$input.data('format'),
      step: parseInt(this.$input.data('step'), 10)
    };
  }

  show() {
    return this.$input.datetimepicker('show');
  }

};

DateTimePicker = class DateTimePicker extends DateTimePickerBase {
  options() {
    return {
      formatDate: this.$input.data('format-date'),
      defaultTime: this.$input.data('default-time'),
      dayOfWeekStart: this.$input.data('week-start-day'),
      disabledDates: this.$input.data('disabled-dates') || [],
      minDate: this.$input.data('min-date'),
      maxDate: this.$input.data('max-date')
    };
  }

};

DatePicker = class DatePicker extends DateTimePickerBase {
  options() {
    return {
      timepicker: false,
      formatDate: this.$input.data('format-date'),
      dayOfWeekStart: this.$input.data('week-start-day'),
      disabledDates: this.$input.data('disabled-dates') || [],
      minDate: this.$input.data('min-date'),
      maxDate: this.$input.data('max-date')
    };
  }

};

TimePicker = class TimePicker extends DateTimePickerBase {
  options() {
    return {
      datepicker: false,
      defaultTime: this.$input.data('default-time')
    };
  }

};

$.simpleForm.onDomReady(function($document) {
  // Plugin initialization delegated to body, so we do not need to run the
  // initialization process when the body has not changed
  if (!$document.is('body')) {
    return;
  }
  $('body').on('click', 'input.datetime', function(e) {
    return DateTimePicker.forInput($(e.currentTarget), DateTimePicker).show();
  });
  $('body').on('click', '.datetime .datetimepicker-trigger', function(e) {
    var $input;
    $input = $(e.currentTarget).closest('.datetime').find('input.datetime');
    return DateTimePicker.forInput($input, DateTimePicker).show();
  });
  $('body').on('click', 'input.date', function(e) {
    return DatePicker.forInput($(e.currentTarget), DatePicker).show();
  });
  $('body').on('click', '.date .datetimepicker-trigger', function(e) {
    var $input;
    $input = $(e.currentTarget).closest('.date').find('input.date');
    return DatePicker.forInput($input, DatePicker).show();
  });
  $('body').on('click', 'input.time', function(e) {
    return TimePicker.forInput($(e.currentTarget), TimePicker).show();
  });
  return $('body').on('click', '.time .datetimepicker-trigger', function(e) {
    var $input;
    $input = $(e.currentTarget).closest('.time').find('input.time');
    return TimePicker.forInput($input, TimePicker).show();
  });
});
