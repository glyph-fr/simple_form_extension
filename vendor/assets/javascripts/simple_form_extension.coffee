#= require redactor-rails/redactor
#= require redactor-rails/langs/fr
#= require redactor-rails/plugins
#= require selectize
#= require spinbox
#= require jasny-bootstrap
#= require jquery.datetimepicker
#= require bootstrap-slider
#= require bootstrap-colorpicker
#= require_self
#= require_tree ./simple_form_extension

$.simpleForm =
  # Bind a callback to run when a DOM or sub-DOM is ready to be initialized
  # Allows abstracting the following cases :
  #   - Document is ready with $(document).ready()
  #   - Document is ready with Turbolinks $(document).on('page:change')
  #   - A sub-DOM is dynamically added and needs all the plugins to be
  #     initialized, ex: for nested forms
  #
  onDomReady: (callback) ->
    $(document).on 'initialize.simpleform', (e, $fragment) ->
      callback($fragment)

# Trigger all the registered callbacks and run them on the target element
$.fn.simpleForm = ->
  @each (i, fragment) ->
    $(document).trigger('initialize.simpleform', [$(fragment)])

# Classic document ready binding
# Does not run when Turbolinks is present and supported by the browser
#
$(document).ready ->
  $('body').simpleForm() unless window.Turbolinks && window.Turbolinks.supported

# Turbolinks document ready binding
#
$(document).on 'page:change', ->
  $('body').simpleForm()
