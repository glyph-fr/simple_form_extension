class ColorPicker
  constructor: (@$el) ->
    @$el.colorpicker()

$.fn.simpleFormColorpicker = ->
  @each (i, el) ->
    $input = $(el)
    return if $input.data('simple-form:colorpicker')
    instance = new ColorPicker($input)
    $input.data('simple-form:colorpicker', instance)

$.simpleForm.onDomReady ($document) ->
  $document.find('[data-colorpicker]').simpleFormColorpicker()
