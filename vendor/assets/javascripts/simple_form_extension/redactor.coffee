onPageReady ->
  csrf_token = $('meta[name=csrf-token]').attr('content')
  csrf_param = $('meta[name=csrf-param]').attr('content')

  if (csrf_param isnt undefined and csrf_token isnt undefined)
    params = csrf_param + "=" + encodeURIComponent(csrf_token);

  $('[data-redactor]').each (i, el) ->
    $textArea = $(el)
    # Avoid double initialization
    unless $textArea.data('initialized.redactor')
      $textArea.redactor
        buttons: ['html', 'formatting',  'bold', 'italic', 'underline', 'deleted',
          'unorderedlist', 'orderedlist', 'outdent', 'indent',
          'image', 'video', 'file', 'table', 'link', 'alignment', 'horizontalrule']
        minHeight: 400
        plugins: [
          "fontcolor"
          "fontsize"
        ]
        imageUpload: ["/redactor_rails/pictures", params].join('?')
        imageGetJson: "/redactor_rails/pictures"
        path: "/assets/redactor-rails"
        css: "style.css"
        lang: "fr"
      $textArea.data('initialized.redactor', true)

  $('[data-air-redactor]').each (i, el) ->
    $textArea = $(el)
    # Avoid double initialization
    unless $textArea.data('initialized.redactor')
      $textArea.redactor
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
        # lang: "fr"      
        
      $textArea.data('initialized.redactor', true)

