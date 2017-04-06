class PeriodPickerBase
  @forInput = ($input, type) ->
    if (picker = $input.data('simple-form-extension-periodpicker'))
      picker
    else
      new type($input)

  constructor: (@$input) ->
    @locale = $('html').attr('lang') || 'en'
    # $.periodpicker.setLocale(@locale)
    @$input.data('simple-form-extension-periodpicker', this)
    
    @$enDateField = @$input.closest('[data-periodpicker-container]')
                      .find('[data-end-date-field]')

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


class DateTimePicker extends PeriodPickerBase
  options: ->
    end: @$enDateField
    formatDate: @$input.data('format-date')
    defaultTime: @$input.data('default-time')
    dayOfWeekStart: @$input.data('week-start-day')
    disabledDates: @$input.data('disabled-dates') || []
    minDate: @$input.data('min-date')
    maxDate: @$input.data('max-date')
    yearsLine: @$input.data('years-line')
    title: @$input.data('title')
    withoutBottomPanel: @$input.data('without-bottom-panel')
    cells: @$input.data('cells')


# class DatePicker extends PeriodPickerBase
#   options: ->
#     timepicker: false
#     formatDate: @$input.data('format-date')
#     dayOfWeekStart: @$input.data('week-start-day')
#     disabledDates: @$input.data('disabled-dates') || []
#     minDate: @$input.data('min-date')
#     maxDate: @$input.data('max-date')


# class TimePicker extends PeriodPickerBase
#   options: ->
#     datepicker: false
#     defaultTime: @$input.data('default-time')


$.simpleForm.onDomReady ($document) ->
  $document.find('[data-period-date-picker]').each (i, el) ->
    DateTimePicker.forInput($(el), DateTimePicker)


  # $('body').on 'click', 'input.date', (e) ->
  #   DatePicker.forInput($(e.currentTarget), DatePicker).show()

  # $('body').on 'click', '.date .periodpicker-trigger', (e) ->
  #   $input = $(e.currentTarget).closest('.date').find('input.date')
  #   DatePicker.forInput($input, DatePicker).show()

  # $('body').on 'click', 'input.time', (e) ->
  #   TimePicker.forInput($(e.currentTarget), TimePicker).show()

  # $('body').on 'click', '.time .periodpicker-trigger', (e) ->
  #   $input = $(e.currentTarget).closest('.time').find('input.time')
  #   TimePicker.forInput($input, TimePicker).show()

