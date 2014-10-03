#= require redactor-rails/redactor.min
#= require jquery.datetimepicker
#= require_self
#= require_tree ./simple_form_extension

window.onPageReady = (callback) ->
  $(document).ready ->
    callback() if Turbolinks is undefined

  $(document).on('page:change', callback);
