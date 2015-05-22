class Slider
  constructor: (@$el) ->
    if @$el.bootstrapSlider
      @$el.bootstrapSlider()
    else
      @$el.slider()

$.fn.simpleFormSlider = ->
  @each (i, el) ->
    $select = $(el)
    return if $select.data('simple-form:slider')
    instance = new Slider($select)
    $select.data('simple-form:slider', instance)

$.simpleForm.onDomReady ($document) ->
  $document.find('[data-slider]').simpleFormSlider()
