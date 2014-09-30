initRedactor = ->
  csrf_token = $('meta[name=csrf-token]').attr('content')
  csrf_param = $('meta[name=csrf-param]').attr('content')

  if (csrf_param isnt undefined and csrf_token isnt undefined)
    params = csrf_param + "=" + encodeURIComponent(csrf_token);

  $('[data-redactor]').each (i, el) ->
    $textArea = $(el)
    # Avoid double initialization
    unless $textArea.data('initialized.redactor')
      $textArea.redactor
        imageUpload: "/redactor_rails/pictures?" + params
        imageGetJson: "/redactor_rails/pictures"
        path: "/assets/redactor-rails"
        css: "style.css"
      $textArea.data('initialized.redactor', true)

$(document).ready(initRedactor);
$(window).bind('page:change', initRedactor);
