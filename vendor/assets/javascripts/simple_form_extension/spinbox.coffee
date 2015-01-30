class Spinbox
  constructor: (@$el) ->
    @el = @$el[0]

    @$el.spinbox(max: Number.POSITIVE_INFINITY)
      
         
onPageReady ->
  $spinbox = $('.spinner-box-input')

  return unless $spinbox.length

  $spinbox.each (i, el) ->
    $spinner = $(el)
    return if $spinner.data('simple-form:spinner')
    instance = new Spinbox($spinner)
    $spinner.data('simple-form:spinner', instance)
