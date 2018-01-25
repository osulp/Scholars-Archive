source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.0'
gem 'puma_worker_killer'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Sidekiq for background job processing with Redis
gem 'sidekiq'
gem 'edtf', github: 'inukshuk/edtf-ruby', branch: 'master'
gem 'blacklight_range_limit'

# MySQL for staging/production servers
gem 'mysql2', '~> 0.3.18'
# Use Capistrano for deployment
gem 'capistrano', '~> 3.8.0'
gem 'capistrano-rails'
gem 'capistrano-passenger'
gem 'capistrano-rbenv'
gem 'capistrano3-puma'
gem 'hydra-role-management'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'hyrax', github: 'samvera/hyrax', tag: 'v2.0.0'
gem 'rsolr', '~> 1.0'
gem 'devise'
gem 'devise-guests', '~> 0.5'

# CAS Authentication gems
gem 'rubycas-client', git: 'https://github.com/osulp/rubycas-client'
gem 'rubycas-client-rails', git: 'https://github.com/osulp/rubycas-client-rails'
gem 'devise_cas_authenticatable'
gem 'sitemap_generator'

# Used for integration of Blazegraph backend and required API
gem 'triplestore-adapter', git: 'https://github.com/osulp/triplestore-adapter'

gem 'staccato'

gem 'browse-everything'

gem 'blacklight_oai_provider', git: 'https://github.com/UNC-Libraries/blacklight_oai_provider.git', branch: 'master'

gem "recaptcha", require: "recaptcha/rails"

group :development do
  # Use Capistrano for deployment
  gem 'capistrano-rails'

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
  gem 'fcrepo_wrapper'
  gem 'rspec-rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :test do
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'coveralls'
  gem 'rspec_junit_formatter'
  gem 'rspec'
  gem 'rspec-mocks'
  gem 'simplecov'
  gem 'webmock'
  gem 'poltergeist'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'equivalent-xml'
end
