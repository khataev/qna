source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'haml-rails'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootstrap-sass-extras'
gem 'devise'
gem 'launchy'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'
gem 'private_pub'
gem 'thin'
gem 'skim'
gem 'responders'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.9.5'
gem 'oj'
gem 'oj_mimic_json'
gem 'sidekiq'
gem 'sinatra', require: nil
gem 'whenever'
gem 'mysql2'
gem 'thinking-sphinx'
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'
gem 'therubyracer'
gem 'unicorn'
gem 'redis-rails'

group :development do
  gem 'spring-commands-rspec'
  gem 'fasterer', require: false
  gem 'brakeman', require: false
  gem 'letter_opener'

  # capistrano
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
  gem 'pry-rails'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'bullet'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'quiet_assets'
  gem 'capybara-email'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'json_spec'
  gem 'poltergeist'
  # Acces an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'
end
