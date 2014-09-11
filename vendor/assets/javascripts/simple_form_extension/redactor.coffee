initRedactor = ->
  csrf_token = $('meta[name=csrf-token]').attr('content')
  csrf_param = $('meta[name=csrf-param]').attr('content')

  if (csrf_param isnt undefined and csrf_token isnt undefined)
    params = csrf_param + "=" + encodeURIComponent(csrf_token);

  $('[data-redactor]').redactor(
    imageUpload: "/redactor_rails/pictures?" + params
    imageGetJson: "/redactor_rails/pictures"
    path: "/assets/redactor-rails"
    css: "style.css"
  )

$(document).ready(initRedactor);
$(window).bind('page:change', initRedactor);
