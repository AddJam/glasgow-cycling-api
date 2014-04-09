source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1.0.rc1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'pg', '~> 0.17.1'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn'

# Analytics
gem 'newrelic_rpm'

# Use Capistrano for deployment
gem 'capistrano'
gem 'rvm-capistrano'

# Use debugger
# gem 'debugger', group: [:development, :test]

# Users + Auth
gem 'devise'

# Image handling
gem "paperclip", "~> 4.1"

# Geocoding
gem 'geocoder'
gem 'redis' #cache

# Development
group :development do
	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'annotate', ">=2.6.0"

	# Automation
	gem 'guard'
	gem 'guard-rails' # Auto restart rails
	gem 'guard-minitest' # Auto test
	gem 'terminal-notifier-guard'
end

# Test
group :test do
	gem "factory_girl_rails", "~> 4.0"
	gem "stepford"
	gem "minitest"
end
