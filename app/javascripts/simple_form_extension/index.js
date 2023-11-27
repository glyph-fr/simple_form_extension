$.simpleForm = {
  // Bind a callback to run when a DOM or sub-DOM is ready to be initialized
  // Allows abstracting the following cases :
  //   - Document is ready with $(document).ready()
  //   - Document is ready with Turbolinks 'page:change' or 'turbolinks:load'
  //   - A sub-DOM is dynamically added and needs all the plugins to be
  //     initialized, ex: for nested forms
  //
  onDomReady: function(callback) {
    $(document).on('initialize.simpleform', function(_e, $fragment) {
      callback($fragment);
    });
  }
}

// Trigger all the registered callbacks and run them on the target element
$.fn.simpleForm = function () {
  this.each(function (i, fragment) {
    $(document).trigger('initialize.simpleform', [$(fragment)])
  });
};

const initializeSimpleForm = function (target) {
  const $target = $(target);

  if ($target.data('simple-form:initialized')) return;

  $target.data('simple-form:initialized', true);
  $target.simpleForm();
};

// Turbo document ready binding
// $(document).on('turbo:load turbo:frame-load turbo:render turbo:frame-render', function (event) {
$(document).on(
  'turbo:load turbo:frame-load turbo:render', 
  (event) => {
    var target = event.target === document.documentElement ? 'body' : event.target;

    console.log("+ Intializing simple form from", event.type, "on", target);
    initializeSimpleForm(target);
  }
);

$(document).on('turbo:before-frame-render', function (event) {
  const defaultRenderAction = event.detail.render

  event.detail.render = function (currentElement, newElement) {
    defaultRenderAction(currentElement, newElement);

    console.log("- Intializing simple form from", event.type, "on", newElement);

    initializeSimpleForm(newElement);
  };
});

$(document).on('turbo:before-stream-render', function (event) {
  const defaultRenderAction = event.detail.render

  event.detail.render = function (streamElement) {
    defaultRenderAction(streamElement);

    console.log("- Intializing simple form from", event.type, "on", streamElement.target);
    
    const target = document.getElementById(streamElement.target);
    initializeSimpleForm(target);
  };
});