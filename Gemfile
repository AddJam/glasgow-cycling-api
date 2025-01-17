source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1.8'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.4.1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'pg', '~> 0.17.1'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn'
gem 'rack-cors', :require => 'rack/cors'

# Performance
gem "skylight"

# Deployment
gem 'capistrano', '2.15.5'
gem 'rvm-capistrano', require: false
gem 'foreman'

# Use debugger
# gem 'debugger', group: [:development, :test]

# Security
gem 'devise', "~> 3.2"
gem 'doorkeeper', "~> 1.4.1"

# Image handling
gem "paperclip", "~> 4.1"

# Location
gem 'geocoder'
gem 'maidenhead'

# Cache
gem 'redis'
gem 'redis-rails'

# Weather
gem 'forecast_io'

# Timed tasks and workers
gem 'sidekiq', '~> 3.0.0'
gem 'clockwork'

# Website
gem 'ember-rails'
gem 'ember-source', '~> 1.9.0'
gem 'bourbon'
gem 'neat'
gem 'bitters'

# Development
group :development do
	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'annotate', ">=2.6.0"
	gem 'railroady'
	gem 'pry-rails'
	gem 'pry-byebug'

	# Automation
	gem 'guard'
	gem 'guard-rails' # Auto restart rails
	gem 'guard-minitest' # Auto test
	gem 'terminal-notifier-guard'

	# Easier usage of tests
	gem 'single_test'
end

# Test
group :test do
	gem "factory_girl_rails", "~> 4.0"
	gem "stepford"
	gem "minitest"
	gem "minitest-reporters"
	gem "mocha"
end
