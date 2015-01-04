class Selectize
  constructor: (@$el) ->
    @single = @$el.data('multi') is false
    @el = @$el[0]

    creatable = @$el.data('creatable')
    addTranslation = @$el.data('add-translation')

    @$el.val('')

    @$el.selectize(
      mode: if @single then 'single' else 'multi'
      sortField: 'text'
      plugins: ['remove_button']
      create: creatable
      render: @renderOptions()
      options: @$el.data('collection')
    )

    if (value = @$el.data('value'))
      @initializeValue(value)

  initializeValue: (data) ->
    if @single
      @el.selectize.addOption(data)
    else
      $.each data, (i, item) => @el.selectize.addOption(item)

    if @single
      @el.selectize.addItem(data.value)
    else
      $.each data, (i, item) => @el.selectize.addItem(item.value)

  addAndSelect: (data) ->
    @el.selectize.addOption(data)
    @el.selectize.addItem(data.value)

  renderOptions: ->
    option_create: (data) ->
      """
        <div class="create" data-selectable="">
          #{ @addTranslation } <strong>#{ data.input }</strong> ...
        </div>
      """

$.fn.simpleFormSelectize = ->
  @each (i, el) ->
    $select = $(el)
    return if $select.data('simple-form:selectize')
    instance = new Selectize($select)
    $select.data('simple-form:selectize', instance)

onPageReady ->
  $('[data-selectize]').simpleFormSelectize()
