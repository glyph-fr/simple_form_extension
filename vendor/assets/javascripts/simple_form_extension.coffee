#= require redactor-rails/redactor
#= require redactor-rails/langs/fr
#= require redactor-rails/plugins
#= require selectize
#= require spinbox
#= require jasny-bootstrap
#= require jquery.datetimepicker
#= require_self
#= require_tree ./simple_form_extension

$.fn.simpleForm = {}

window.onPageReady = (callback) ->
  $(document).ready ->
    callback() if Turbolinks is undefined

  $(document).on('page:change', callback);
