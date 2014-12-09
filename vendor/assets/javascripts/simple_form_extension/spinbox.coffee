class Spinbox
  constructor: (@$el) ->
    @el = @$el[0]

    @$el.spinbox()

onPageReady ->
  $spinbox = $('.spinner')

  return unless $spinbox.length

  $spinbox.each (i, el) ->
    $spinner = $(el)
    return if $spinner.data('simple-form:spinner')
    instance = new Spinbox($spinner)
    $spinner.data('simple-form:spinner', instance)
