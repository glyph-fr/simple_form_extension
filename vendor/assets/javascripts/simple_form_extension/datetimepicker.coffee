class DateTimePickerBase
  @forInput = ($input, type) ->
    if (picker = $input.data('simple-form-extension-datetimepicker'))
      picker
    else
      new type($input)

  constructor: (@$input) ->
    @locale = $('html').attr('lang') || 'en'
    $.datetimepicker.setLocale(@locale)
    @$input.data('simple-form-extension-datetimepicker', this)
    @initializePicker()

  initializePicker: ->
    @$input.datetimepicker(@processOptions())

  processOptions: ->
    $.extend({}, @defaultOptions(), @options())

  options: ->
    {}

  defaultOptions: ->
    lang: @locale
    format: @$input.data('format')
    step: parseInt(@$input.data('step'), 10)

  show: ->
    @$input.datetimepicker('show')


class DateTimePicker extends DateTimePickerBase
  options: ->
    formatDate: @$input.data('format-date')
    defaultTime: @$input.data('default-time')
    dayOfWeekStart: @$input.data('week-start-day')
    disabledDates: @$input.data('disabled-dates') || []
    minDate: @$input.data('min-date')
    maxDate: @$input.data('max-date')


class DatePicker extends DateTimePickerBase
  options: ->
    timepicker: false
    formatDate: @$input.data('format-date')
    dayOfWeekStart: @$input.data('week-start-day')
    disabledDates: @$input.data('disabled-dates') || []
    minDate: @$input.data('min-date')
    maxDate: @$input.data('max-date')


class TimePicker extends DateTimePickerBase
  options: ->
    datepicker: false,
    defaultTime: @$input.data('default-time')


$.simpleForm.onDomReady ($document) ->
  # Plugin initialization delegated to body, so we do not need to run the
  # initialization process when the body has not changed
  return unless $document.is('body')

  $('body').on 'click', 'input.datetime', (e) ->
    DateTimePicker.forInput($(e.currentTarget), DateTimePicker).show()

  $('body').on 'click', '.datetime .datetimepicker-trigger', (e) ->
    $input = $(e.currentTarget).closest('.datetime').find('input.datetime')
    DateTimePicker.forInput($input, DateTimePicker).show()

  $('body').on 'click', 'input.date', (e) ->
    DatePicker.forInput($(e.currentTarget), DatePicker).show()

  $('body').on 'click', '.date .datetimepicker-trigger', (e) ->
    $input = $(e.currentTarget).closest('.date').find('input.date')
    DatePicker.forInput($input, DatePicker).show()

  $('body').on 'click', 'input.time', (e) ->
    TimePicker.forInput($(e.currentTarget), TimePicker).show()

  $('body').on 'click', '.time .datetimepicker-trigger', (e) ->
    $input = $(e.currentTarget).closest('.time').find('input.time')
    TimePicker.forInput($input, TimePicker).show()

