class Slider
  constructor: (@$el) ->
    values = @$el.data('slider-value').split(',')
    value = if values.length <= 1 then value[0] else (parseInt(value, 10) for value in values)

    if @$el.bootstrapSlider
      @$el.bootstrapSlider(value: value)
    else
      @$el.slider(value: value)

$.fn.simpleFormSlider = ->
  @each (i, el) ->
    $select = $(el)
    return if $select.data('simple-form:slider')
    instance = new Slider($select)
    $select.data('simple-form:slider', instance)

$.simpleForm.onDomReady ($document) ->
  $document.find('[data-slider]').simpleFormSlider()
