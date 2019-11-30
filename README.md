# kadim
Yet another Rails admin? No, only a kadim!&#42;

Admin is all about CRUD, right?

My biggest experience with admins is with RailsAdmin. I currently work with an application that makes extensive use of
it and all my peers hate having to customize anything on it, me too!

If I have used administrate or trestle? Yes, I've tried it, but isn't reinventing the wheel super cool? In fact I
believe a less DSL-focused admin would be better.

I just got annoyed at just criticizing existing solutions and decided to get my hands dirty to put my vision into
practice.

*&#42; kadim: derived from "cadim", an expression from the brazillian mineiro dialect that means "a little bit".*

## Usage
In the current incarnation, it's very crud (no pun intended) and there is no configuration, everything works by
convention.

For each model of your application will be generated a controller and their views, using the Rails generator
scaffold_controller, using all columns present in your model. Relations, ActiveStorage attachments and other
ActiveRecord methods added by gems are ignored.

Files are generated in `tmp/kadim` and loaded into memory, including views. This also has the advantage of allowing the
gem to work in environments with ephemeral file systems.

## Customization

You can manually copy kadim files and put them in the same path within your application. You will probably want to do
this with the main kadim controller, to add safety rules, etc.

You also provide two generators to make this task easier.

```bash
rails g kadim: host
rails g kadim: host: scaffold_controller ModelName
```

The first one copies the basic kadim infrastructure to your application, ie the
[main controller](app/controllers/kadim/application_controller.rb), the
[main view](app/views/kadim/application/index.html.erb) and its [layout](app/views/layouts/kadim/application.html.erb),
a [helper](app/helpers/kadim/application_helper.rb) and [assets](app/assets/).

The second copies the files that kadim dynamically generates into your application, allowing you to have full control
over controller and views implementation. This generator is a thin layer over the Rails scaffold_controller, but it only
accepts the model name as a parameter, for attributes all fields of the model are used.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'kadim'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install kadim
```

Mount the engine:
```ruby
mount Kadim::Engine, at: '/kadim'
```

And access http://localhost:3000/kadim

## Roadmap
- [x] Dynamic CRUD generation from application models
- [x] Tasks to copy files form kadim to the hosted application
- [ ] Add support to ActiveStorage attachments
- [ ] Add support to belongs_to relationships
- [ ] Add a beautiful look and feel

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
