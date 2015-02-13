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
          'image', 'file','link', 'alignment', 'horizontalrule']
        removeEmpty: ['strong', 'em', 'span', 'p', 'h1', 'h2', 'h3', 'h4', 'div']
        allowedTags: ['p', 'h1', 'h2', 'pre', 'div']
        minHeight: 400
        buttonSource: true
        replaceDivs: false
        linebreaks: true
        toolbarFixed: false
        imageUpload: ["/redactor_rails/pictures", params].join('?')
        imageManagerJson: "/redactor_rails/pictures"
        fileUpload: ["/redactor_rails/documents", params].join('?')
        fileManagerJson: "/redactor_rails/documents"
        plugins: [
          "clips"
          "filemanager"
          "imagemanager"
          "video"
          "table"
          "fontcolor"
          "fontsize"
        ]
        path: "/assets/redactor-rails"
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
        lang: "fr"      
        
      $textArea.data('initialized.redactor', true)
