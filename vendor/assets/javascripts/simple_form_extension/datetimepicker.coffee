class DateTimePicker
  @forInput = ($input, type) ->
    if (picker = $input.data('simple-form-extension-datetimepicker'))
      picker
    else
      new type($input)

  constructor: (@$input) ->
    @locale = $('html').attr('lang') || 'en'
    @$input.data('simple-form-extension-datetimepicker', this)
    @initializePicker()

  initializePicker: ->
    @$input.datetimepicker(
      lang: @locale
      format: @$input.data('datetime-format')
      dayOfWeekStart: @$input.data('week-start-day')
    )

  show: ->
    @$input.datetimepicker('show')

class DatePicker extends DateTimePicker
  initializePicker: ->
    @$input.datetimepicker(
      lang: @locale
      timepicker: false
      format: @$input.data('date-format')
      dayOfWeekStart: @$input.data('week-start-day')
    )

# Lazy initialization of date and datetime pickers
onPageReady ->
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