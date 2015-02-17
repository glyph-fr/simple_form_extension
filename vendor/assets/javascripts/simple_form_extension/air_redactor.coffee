class AirRedactor
  constructor: (@$el) ->
    @$el.redactor
      air: true
      plugins: [
        "fontcolor"
        "fontsize"
      ]
      airButtons: [
        "bold"
        "italic"
        "fontcolor"
        "fontsize"
        "underline"
        "deleted"
        "link"
      ]
      lang: "fr"

$.fn.simpleFormAirRedactor = ->
  @each (i, el) ->
    $textarea = $(el)
    return if $textarea.data('simple-form:air-redactor')
    instance = new AirRedactor($textarea)
    $textarea.data('simple-form:air-redactor', instance)

onPageReady ->
  $('[data-air-redactor]').simpleFormAirRedactor()

