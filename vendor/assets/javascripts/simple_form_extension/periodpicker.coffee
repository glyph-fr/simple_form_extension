class DateTimePeriodPickerBase
  @forInput = ($input, type) ->
    if (picker = $input.data('simple-form-extension-datetimeperiodpicker'))
      picker
    else
      new type($input)

  constructor: (@$input) ->
    @locale = $('html').attr('lang') || 'en'
    $.periodpicker.setLocale(@locale)
    @$input.data('simple-form-extension-datetimeperiodpicker', this)
    @initializePicker()

  initializePicker: ->
    @$input.periodpicker(@processOptions())

  processOptions: ->
    $.extend({}, @defaultOptions(), @options())

  options: ->
    {}

  defaultOptions: ->
    lang: @locale
    format: @$input.data('format')
    step: parseInt(@$input.data('step'), 10)

  show: ->
    @$input.periodpicker('show')


class DateTimePicker extends DateTimePeriodPickerBase
  options: ->
    end: @$input.data('end-date')
    formatDate: @$input.data('format-date')
    defaultTime: @$input.data('default-time')
    dayOfWeekStart: @$input.data('week-start-day')
    disabledDates: @$input.data('disabled-dates') || []
    minDate: @$input.data('min-date')
    maxDate: @$input.data('max-date')


class DatePicker extends DateTimePeriodPickerBase
  options: ->
    timepicker: false
    formatDate: @$input.data('format-date')
    dayOfWeekStart: @$input.data('week-start-day')
    disabledDates: @$input.data('disabled-dates') || []
    minDate: @$input.data('min-date')
    maxDate: @$input.data('max-date')


class TimePicker extends DateTimePeriodPickerBase
  options: ->
    datepicker: false,
    defaultTime: @$input.data('default-time')


$.simpleForm.onDomReady ($document) ->
  # Plugin initialization delegated to body, so we do not need to run the
  # initialization process when the body has not changed
  return unless $document.is('body')

  $('body').on 'click', 'input.datetime', (e) ->
    DateTimePicker.forInput($(e.currentTarget), DateTimePicker).show()

  $('body').on 'click', '.datetime .periodpicker-trigger', (e) ->
    $input = $(e.currentTarget).closest('.datetime').find('input.datetime')
    DateTimePicker.forInput($input, DateTimePicker).show()

  $('body').on 'click', 'input.date', (e) ->
    DatePicker.forInput($(e.currentTarget), DatePicker).show()

  $('body').on 'click', '.date .periodpicker-trigger', (e) ->
    $input = $(e.currentTarget).closest('.date').find('input.date')
    DatePicker.forInput($input, DatePicker).show()

  $('body').on 'click', 'input.time', (e) ->
    TimePicker.forInput($(e.currentTarget), TimePicker).show()

  $('body').on 'click', '.time .periodpicker-trigger', (e) ->
    $input = $(e.currentTarget).closest('.time').find('input.time')
    TimePicker.forInput($input, TimePicker).show()

