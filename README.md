# Simple Form Extension

This gems adds custom common input types to simple form.

## Available inputs

The following custom Simple Form inputs are available :

* boolean
* collection_check_boxes
* collection_radio_buttons
* date_time
* file
* image
* numeric
* selectize
* slider
* color

Most of those inputs come with built-in javascript plugins, sometimes depending
on external gems, others with the javascript plugin bundled in the gem's vendor
directory.

For more informations on javascript plugins usage, see the
[Javascript plugins section](#javascript-plugins)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_form_extension'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install simple_form_extension
```

Use the install generator :

```bash
rails generate simple_form_extension:install
```

Add to your `application.css` :

```css
 *= require simple_form_extension
```

Add to your `application.js` :

```javascript
//= require simple_form_extension
```

## Usage

There are two types of inputs provided by Simple Form Extension.

### Input overrides

The first are overrides of default Simple Form inputs, which allows for cleaner
defaults. **You have nothing to do to use them**, since they'll be used
automatically when calling `form.input`.

Those inputs are the following :

* boolean
* collection_check_boxes
* collection_radio_buttons
* date_time
* file
* numeric

### New inputs

The other inputs are new ones, that extend the possibilities of your forms.
You need to explicitly call them in your forms with the `:as` parameter.

This inputs are the following :

* [image](#image)
* [selectize](#selectize)
* [slider](#slider)
* [color](#color)

### New Inputs usage

#### :image

The image is built to work with [Paperclip](https://github.com/thoughtbot/paperclip)
attachments.

It allows you to show a preview of the image before uploading it
and a thumbnail of that image when displaying the form after the image
has been uploaded.

```ruby
= form.input :picture, as: :image
```

Optionnaly, the input can add a Remove button to the image.
For this feature to work you have to define a setter on your model that'll
remove the image when given '1' as a value.

As a default, the input will look for a `remove_<attachment_name>` method, and
if it finds it, a Remove button will be added.

```ruby
# app/models/photo.rb
class Photo < ActiveRecord::Base
  has_attached_file :picture

  def remove_picture=(value)
    # Remove your attachment here
  end
end

# app/views/photos/_form.html.haml
= simple_form_for @photo do |form|
  = form.input :picture, as: :image
```

You can customize the name of the setter that will be called with the
`:remove_method` option :

```ruby
= form.input :picture, as: :image, remove_method: :destroy_picture
```

#### :selectize

The selectize field allows you to create a powerful select field using the
[Selectize](https://selectize.github.io/selectize.js/) javascript plugin.

```ruby
= form.input :items, as: :selectize, collection: Item.all
```

The following options are available :

* `:creatable` : allow you to add options that are not initally present in the list
* `:multi` : sets the field to multi mode, allowing users to select multiple items
* `:collection` : sets the collection. Can be any ActiveRecord::Relation
(`#name` and `#title` will be called to define label) or a Hash with { :text, :value }
keys at least
* `:max-items` : When in multi mode, maximum items that can be selected
* `:sort-field` : The name of the collection item's field that will be used for sorting.
You can add a field to the collection and it'll be serialized to JSON and used from
selectize to sort your collection.

```ruby
= form.input :items, as: :selectize, collection: Item.all.map { |item| { text: item.name, value: item.id, position: item.position } }, :'sort-field' => :position, multi: false, creatable: true
```

Used javascript plugin : [Selectize](https://brianreavis.github.io/selectize.js/)

##### Selectize on enums

You can use a selectize input field on
[enums](http://edgeapi.rubyonrails.org/classes/ActiveRecord/Enum.html).

The different options of the enum will be displayed.
You can translate those options by defining the following translation key :
`activerecord.enums.<model_name>.<attribute_name>.<option_name>`.

For example, if we have a `User` model with an `invitation` enum and the
`accepted` state, we'll have to translate : `activerecord.enums.user.invitation.accepted`.

#### :slider

To use the slide component, you'll always want to set the `:min` and `:max`
options.

Use it with :

```ruby
= form.input :field, as: :slider, min: 0, max: 10
```

Options are the following :

* `:step` : Which size the steps should be between :min and :max
* `:orientation` : 'horizontal' or 'vertical', defaults to hotirzontal
* `:range` : set to true for the slider to be a range slider
* `:disabled` : set to true to disable interaction
* `:ticks` : pass an array of ticks to display on the slider, ex: [0, 2, 4, 6, 8, 10]

```ruby
= form.input :field, as: :slider, min: 0, max: 10, step: 2, orientation: 'vertical',
                     range: true, ticks: [0, 5, 10]
```

Used javascript plugin : [Bootstrap Slider](https://github.com/seiyria/bootstrap-slider)

#### :color

The color input allows to add a colorpicker to a string field.

```ruby
= form.input :background_color, as: :color
```

Options :

* format
* align


Used javascript plugin : [Bootstrap Color Picker](http://mjolnic.com/bootstrap-colorpicker/)

<!-- To use the popover component, please include in a javascript file :

```javascript
$('body').popover(selector: '[rel="popover"]')
``` -->

## Javascript Plugins

Simple Form Extension comes with several javascript plugins built-in for the
inputs to work properly.

Plugins are automatically initialized on page load, with or without Turbo.

This means that for a classic page you don't need to initialize anything yourself.

### Manual javascript plugins initialization

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

## Disabling image input file type validation 

By default, Simple Form Extension restricts the image file types users can
select to JPEG, PNG and GIF file types. This is done by using the `accept` 
html attribute of the input tag.

You can turn off this behavior by :

- Setting `SimpleFormExtension.default_image_input_accept = nil` in an 
initializer for an app-wide setting
- Setting `form.input :image, input_html: { accept: nil }` locally on the fields
you want to allow other input types


## Contributing

1. Fork it ( http://github.com/xana68/simple_form_extension/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
