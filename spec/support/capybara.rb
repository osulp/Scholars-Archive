require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Capybara.register_driver(:poltergeist) do |app|
  Capybara::Poltergeist::Driver.new app,
    js_errors: false,
    timeout: 180,
    logger: nil,
    phantomjs_options:
    [
      '--load-images=no',
      '--ignore-ssl-errors=yes'
    ]
end
