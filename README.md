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

If you want to customize `Kadim::ApplicationController`, the basic controller for all generated controllers, you can
copy the file [app/controllers/kadim/application_controller.rb](https://github.com/fnix/kadim/blob/master/app/controllers/kadim/application_controller.rb)
to your application. You can do the same for [app/views/layouts/kadim/application.html.erb](https://github.com/fnix/kadim/blob/master/app/views/layouts/kadim/application.html.erb).
If you want to customize the generated controller/views just copy them from `tmp/kadim` to your application.

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

## Roadmap
- [x] Dynamic CRUD generation from application models
- [ ] Tasks to copy files form kadim to the hosted application
- [ ] Add support to ActiveStorage attachments
- [ ] Add support to belongs_to relationships
- [ ] Add a beautiful look and feel

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
