# SimpleFormExtension

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'simple_form_extension'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_form_extension

Add to your `application.css` :

```css
 *= require simple_form_extension
```

Add to your `application.js` :

```javascript
//= require simple_form_extension
```

## Usage

To use the popover component, please include in a javascript file :

```javascript
$('body').popover(selector: '[rel="popover"]')
```

### Available inputs

The following custom Simple Form inputs are available :

* boolean
* collection_check_boxes
* collection_radio_buttons
* color
* date_time
* file
* image
* numeric
* redactor
* selectize
* slider

### Javascript Plugins

Simple Form Extension comes with several javascript plugins built-in for the
inputs to work properly.

Plugins are automatically initialized on page load, with or without Turbolinks.

This means that for a classic page you don't need to initialize anything yourself.

#### Manual javascript plugins initialization

If you append some HTML, after the page is loaded, containing inputs that you
need to initialize, you'll need to manually call the Simple Form Extension
plugins initialization method.

> Note : Most of the javascript-bound inputs need their associated plugin to be
run to build their final appearance. So their initialization can't be deferred,
and you need to initialize them manually when appending HTML to the page after
the page is loaded

All you need to do is calling the following `simpleForm` jQuery plugin :

```javascript
$fragment.simpleForm()`
```

As an example, if you're loading a form from the server, you can do the
following :

```javascript
$.get('/form/url', function(response) {
  // Store the fragment loaded from the server in a variable
  $fragment = $(response)
  // Append it to the DOM
  $fragment.appendTo('body')
  // Initialize Simple Form Extension plugins
  $fragment.simpleForm()
})
```

## Contributing

1. Fork it ( http://github.com/xana68/simple_form_extension/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
