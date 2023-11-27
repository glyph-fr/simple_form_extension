import Selectize from '@selectize/selectize';

var SimpleFormSelectize, hash_key;

SimpleFormSelectize = class SimpleFormSelectize {
  selectizeDefaults() {
    return {
      mode: this.single ? 'single' : 'multi',
      maxItems: this.single ? 1 : this.$el.data('max-items'),
      sortField: this.$el.data('sort-field'),
      plugins: ['remove_button'],
      create: this.$el.data('creatable'),
      render: this.renderOptions(),
      options: this.$el.data('collection'),
      load: this.load
    };
  }

  constructor($el, options1) {
    var value;
    this.load = this.load.bind(this);
    this.$el = $el;
    this.options = options1;
    this.single = this.$el.data('multi') === false;
    this.el = this.$el[0];
    this.$el.val('');
    this.searchURL = this.$el.data('search-url');
    this.searchParam = this.$el.data('search-param');
    this.escape = this.$el.data('escape') !== false;
    this.$el.selectize($.extend(this.selectizeDefaults(), this.options));
    if ((value = this.$el.data('value'))) {
      this.initializeValue(value);
    }
    // Fix for newest version of selectize that keeps the hidden input field
    // instead of converting it to a text field when we call it on a hidden
    // input.
    this.$el.next('.selectize-control').find('.selectize-input input[type="hidden"]').attr('type', 'text');
  }

  initializeValue(data) {
    if (this.single) {
      this.el.selectize.addOption(data);
    } else {
      $.each(data, (i, item) => {
        return this.el.selectize.addOption(item);
      });
    }
    if (this.single) {
      return this.el.selectize.addItem(data.value);
    } else {
      return $.each(data, (i, item) => {
        return this.el.selectize.addItem(item.value);
      });
    }
  }

  addAndSelect(data) {
    this.el.selectize.addOption(data);
    return this.el.selectize.addItem(data.value);
  }

  load(query, callback) {
    var data;
    if (!(query.length && this.searchURL)) {
      return callback();
    }
    data = {};
    data[this.searchParam] = query;
    return $.ajax({
      url: this.searchURL,
      type: 'GET',
      data: data,
      error: function() {
        return callback();
      },
      success: callback
    });
  }

  renderOptions() {
    return {
      option: (data, escape) => {
        return `<div data-value="${escape(data.value)}" class="item">\n  ${(this.escape ? escape(data.text) : data.text)}\n</div>`;
      },
      item: (data, escape) => {
        return `<div data-value="${escape(data.value)}" data-selectable="" class="option">\n  ${(this.escape ? escape(data.text) : data.text)}\n</div>`;
      },
      option_create: (data) => {
        return `<div class="create" data-selectable="">\n  ${this.$el.data('add-translation')}\n  <strong>${data.input}</strong> ...\n</div>`;
      }
    };
  }

};

$.fn.simpleFormSelectize = function(options = {}) {
  return this.each(function(i, el) {
    var $select, instance;
    $select = $(el);
    if ($select.data('simple-form:selectize')) {
      return;
    }
    instance = new SimpleFormSelectize($select, options);
    return $select.data('simple-form:selectize', instance);
  });
};

$.simpleForm.onDomReady(function($document) {
  return $document.find('[data-selectize]').simpleFormSelectize();
});

// Clean up selectize instances before the turbo page is cached to avoid double 
// initialization of the selectize markup when the page is restored from cache.
$(document).on('turbo:before-cache', function(e) {
  return $('[data-selectize]').each(function(i, el) {
    var $select, selectize;
    $select = $(el);
    if (!$select.data('simple-form:selectize')) {
      return;
    }
    $select.data('simple-form:selectize', null);
    selectize = $select.data('selectize');
    if (selectize != null ? selectize.destroy : void 0) {
      return selectize.destroy();
    }
  });
});

// Fix for allowEmptyOption issue

// See : https://github.com/selectize/selectize.js/issues/967

hash_key = function(value) {
  if (typeof value === 'undefined' || value === null) {
    return null;
  }
  if (typeof value === 'boolean') {
    if (value) {
      return '1';
    } else {
      return '0';
    }
  }
  return value + '';
};

$.extend(Selectize.prototype, {
  registerOption: function(data) {
    var key;
    key = hash_key(data[this.settings.valueField]);
    // Line 1187 of src/selectize.js should be changed
    // if (!key || this.options.hasOwnProperty(key)) return false;
    if (typeof key === 'undefined' || key === null || this.options.hasOwnProperty(key)) {
      return false;
    }
    data.$order = data.$order || ++this.order;
    this.options[key] = data;
    return key;
  }
});
