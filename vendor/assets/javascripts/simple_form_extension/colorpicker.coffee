class ColorPicker
  constructor: (@$el) ->
    if ($parent = @$el.closest('[data-colorpicker-wrapper]')).length
      $parent.colorpicker()
    else
      @$el.colorpicker()

$.fn.simpleFormColorpicker = ->
  @each (i, el) ->
    $input = $(el)
    return if $input.data('simple-form:colorpicker')
    instance = new ColorPicker($input)
    $input.data('simple-form:colorpicker', instance)

$.simpleForm.onDomReady ($document) ->
  $document.find('[data-colorpicker]').simpleFormColorpicker()
