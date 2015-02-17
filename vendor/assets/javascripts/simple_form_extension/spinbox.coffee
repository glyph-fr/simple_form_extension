class Spinbox
  constructor: (@$el) ->
    @$el.spinbox(max: Number.POSITIVE_INFINITY)
      

$.fn.simpleFormSpinbox = ->
  @each (i, el) ->
    $input = $(el)
    return if $input.data('simple-form:spinbox')
    instance = new Spinbox($input)
    $input.data('simple-form:spinbox', instance)
         
onPageReady ->
  $spinbox = $('.spinner-box-input')
  return unless $spinbox.length
  $spinbox.simpleFormSpinbox()
