require 'rails_helper'
require 'capybara/poltergeist'
require 'capybara/email/rspec'

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# Capybara.javascript_driver = :webkit
# # Capybara.javascript_driver = :selenium
# Capybara.default_max_wait_time = 5
# Capybara.ignore_hidden_elements = true
# Capybara.server_port = 1234

# Capybara::Webkit.configure do |config|
#   # config.debug = true
# end

Capybara.register_driver :selenium do |app|
  Selenium::WebDriver::Firefox::Binary.path = "/usr/bin/firefox-47/firefox"
  Capybara::Selenium::Driver.new(
      app,
      browser: :firefox,
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
  )
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, phantomjs_logger: File.open("log/test_phantomjs.log", "a"))
end

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: true, js_errors: false, phantomjs_logger: File.open("log/test_phantomjs.log", "a")
  )
end

# Capybara.current_driver = :selenium # uncomment to view non-js feature tests in browser
if ENV['RSPEC_WEBDRIVER'].present?
  Capybara.javascript_driver = ENV['RSPEC_WEBDRIVER'].to_sym
else
  Capybara.javascript_driver = :poltergeist # driver for js: true tests
end
Capybara.default_max_wait_time = 5
Capybara.ignore_hidden_elements = false
Capybara.server_port = 1234
Capybara.raise_server_errors = false
