source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'sprockets', '~>2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'sufia', github: "osulp/sufia", branch: '6.x-stable-dev'
gem 'kaminari', github: 'jcoyne/kaminari', branch: 'sufia'
gem 'active-fedora', :github => 'projecthydra/active_fedora', :tag => "v9.7.1"

# Deploy
gem 'capistrano', '~>2.0'

# Server
gem 'passenger'

# MySQL
gem 'mysql2', '~> 0.3.18'

gem 'linkeddata', '1.1.11'

gem 'marmotta'

gem 'config', github: 'railsconfig/config'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry', '~> 0.10.0'
  gem 'pry-byebug'
  gem 'capybara'
  gem 'poltergeist'
  gem 'coveralls'
end


gem 'rsolr', '~> 1.0.6'
gem 'devise'
gem 'devise-guests', '~> 0.3'

gem 'rubycas-client', git: 'git://github.com/terrellt/rubycas-client.git', branch: 'master'
gem 'rubycas-client-rails', :git => 'git://github.com/osulp/rubycas-client-rails.git'
gem 'devise_cas_authenticatable'
gem 'hydra-editor', :github => "jechols/hydra-editor", :branch => "feature/configurable-field-generator"
gem 'attr_extras'
# perform server-side Google Analytics events/views/etc
gem 'staccato'

group :development, :test do
  # gem 'jettywrapper'
  gem 'jettywrapper', :github => "projecthydra/jettywrapper"
end
