class Selectize

  selectizeDefaults: ->
    mode: if @single then 'single' else 'multi'
    maxItems: if @single then 1 else @$el.data('max-items')
    sortField: 'text'
    plugins: ['remove_button']
    create: @creatable
    render: @renderOptions()
    options: @$el.data('collection')

  constructor: (@$el, @options) ->
    @single = @$el.data('multi') is false
    @el = @$el[0]

    @creatable = @$el.data('creatable')

    @$el.val('')

    @$el.selectize(
      _.defaults @options, @selectizeDefaults()
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
    option_create: (data) =>
      """
        <div class="create" data-selectable="">
          #{ @$el.data('add-translation') }
          <strong>#{ data.input }</strong> ...
        </div>
      """

$.fn.simpleFormSelectize = (options = {}) ->
  @each (i, el) ->
    $select = $(el)
    return if $select.data('simple-form:selectize')
    instance = new Selectize($select, options)
    $select.data('simple-form:selectize', instance)

onPageReady ->
  $('[data-selectize]').simpleFormSelectize()
