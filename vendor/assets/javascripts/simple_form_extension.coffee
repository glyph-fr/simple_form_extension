#= require redactor-rails/redactor.min
#= require redactor-rails/langs/fr
#= require redactor-rails/plugins
#= require selectize
#= require jquery.datetimepicker
#= require_self
#= require_tree ./simple_form_extension

window.onPageReady = (callback) ->
  $(document).ready ->
    callback() if Turbolinks is undefined

  $(document).on('page:change', callback);
