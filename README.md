# README

Things you have to do:

* Ruby version 2.3.0

* Create `config/database.yml` from `config/database.example.yml`

* `$ rvm 2.3.0; rvm gemset create kickoff`

* `$ echo kickoff > .ruby-gemset`

* `$ echo ruby-2.3.0 > .ruby-version`

* Database initialization: `bin/rails db:create; bin/rails db:migrate`

* How to run the test suite: `bin/rspec` or `bundle exec rspec`

## Rename App

Change the name kickoff by your app name in each of these files

* kickoff/app/views/layouts/application.html.erb
```html
    2  <html>
    3    <head>
    4:     <title><%= content_for?(:title) ? yield(:title) : "Kickoff" %> </title>
    5      <%= csrf_meta_tags %>
    6      <meta name="viewport" content="width=device-width, initial-scale=1">
```

* kickoff/config/application.rb
```rb
    7  Bundler.require(*Rails.groups)
    8
    9: module Kickoff
   10    class Application < Rails::Application
   11      # Settings in config/environments/* take precedence over those specified here.
```

* kickoff/config/environments/production.rb
```rb
   55    # Use a real queuing backend for Active Job (and separate queues per environment)
   56    # config.active_job.queue_adapter     = :resque
   57:   # config.active_job.queue_name_prefix = "kickoff_#{Rails.env}"
   58    config.action_mailer.perform_caching = false
   59
```

* kickoff/config/initializers/session_store.rb
```rb
    1  # Be sure to restart your server when you modify this file.
    2
    3: Rails.application.config.session_store :cookie_store, key: '_kickoff_session'
    4
```

## RuboCop

* [Manual][rubocop]

* Add your app name in `.pronto.yml`

## Extra Gems

* [devise][devise]
* [react-rails][react]
* [sprockets-es6][sprockets]

## Template

* [Gentelella][template]  

**Ready for Heroku** 🦁

[devise]: https://github.com/plataformatec/devise
[react]: https://github.com/reactjs/react-rails
[sprockets]: https://github.com/TannerRogalsky/sprockets-es6
[rubocop]: http://rubocop.readthedocs.io/en/latest/
[template]: https://github.com/puikinsh/gentelella
