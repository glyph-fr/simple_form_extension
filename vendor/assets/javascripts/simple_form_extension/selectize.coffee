class Selectize
  selectizeDefaults: ->
    mode: if @single then 'single' else 'multi'
    maxItems: if @single then 1 else @$el.data('max-items')
    sortField: @$el.data('sort-field')
    plugins: ['remove_button']
    create: @$el.data('creatable')
    render: @renderOptions()
    options: @$el.data('collection')
    load: @load

  constructor: (@$el, @options) ->
    @single = @$el.data('multi') is false
    @el = @$el[0]
    @$el.val('')

    @searchURL = @$el.data('search-url')
    @searchParam = @$el.data('search-param')
    @escape = @$el.data('escape') isnt false

    @$el.selectize($.extend @selectizeDefaults(), @options)

    if (value = @$el.data('value'))
      @initializeValue(value)

    # Fix for newest version of selectize that keeps the hidden input field
    # instead of converting it to a text field when we call it on a hidden
    # input.
    @$el.next('.selectize-control')
        .find('.selectize-input input[type="hidden"]')
        .attr('type', 'text')

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

  load: (query, callback) =>
    return callback() unless query.length && @searchURL

    data = {}
    data[@searchParam] = query

    $.ajax
      url: @searchURL
      type: 'GET'
      data: data
      error: -> callback()
      success: callback

  renderOptions: ->
    option: (data, escape) =>
      """
        <div data-value="#{ escape(data.value) }" class="item">
          #{ if @escape then escape(data.text) else data.text }
        </div>
      """

    item: (data, escape) =>
      """
        <div data-value="#{ escape(data.value) }" data-selectable="" class="option">
          #{ if @escape then escape(data.text) else data.text }
        </div>
      """

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

$.simpleForm.onDomReady ($document) ->
  $document.find('[data-selectize]').simpleFormSelectize()


# Fix for allowEmptyOption issue
#
# See : https://github.com/selectize/selectize.js/issues/967
#
hash_key = (value) ->
  if typeof value == 'undefined' or value == null
    return null
  if typeof value == 'boolean'
    return if value then '1' else '0'
  value + ''

$.extend window.Selectize.prototype, registerOption: (data) ->
  key = hash_key(data[@settings.valueField])
  # Line 1187 of src/selectize.js should be changed
  # if (!key || this.options.hasOwnProperty(key)) return false;
  if typeof key == 'undefined' or key == null or @options.hasOwnProperty(key)
    return false
  data.$order = data.$order or ++@order
  @options[key] = data
  key
