source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.5'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 5.6.4'

# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1'
# Use Chosen.js to render type-ahead advanced search facets
gem 'chosen-rails', '~> 1.9'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Sidekiq for background job processing with Redis
gem 'sidekiq', '7.0.8'
gem 'ffi', '~> 1.15.0'

gem 'blacklight_oai_provider'
gem 'blacklight_range_limit'
gem 'edtf', github: 'inukshuk/edtf-ruby', branch: 'master'

gem 'blacklight_advanced_search'

# MySQL for staging/production servers
gem 'mysql2', '~> 0.5.1'
# Use Capistrano for deployment
gem 'hydra-role-management'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'browse-everything'
gem 'devise'
gem 'devise-guests', '~> 0.5'
gem 'devise_cas_authenticatable'
gem 'faraday'
gem 'hyrax', github: 'samvera/hyrax', tag: 'v2.9.5'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'invisible_captcha'
gem 'rsolr'
gem 'staccato'
gem 'dalli'
# CAS Authentication gems
gem 'rubycas-client', git: 'https://github.com/osulp/rubycas-client'
gem 'rubycas-client-rails', git: 'https://github.com/osulp/rubycas-client-rails'
gem 'sitemap_generator'

# Used for integration of Blazegraph backend and required API
# net-http-persistent 3.0 changes cause triplestore-adapter to break, awaiting fix for that
gem 'net-http-persistent'
gem 'triplestore-adapter', git: 'https://github.com/osulp/triplestore-adapter', branch: 'master'

# simple_form 3.5.1 broke hydra-editor for certain model types;
#   see: https://github.com/plataformatec/simple_form/issues/1549
gem 'simple_form', '~> 5.0'

# Gem vulnerability fix
gem 'rest-client', '~> 2.0'

# For asset precompiled error pages, and/or general use because it's way better than ERB
gem 'haml'

gem 'bagit', '~>0.4.1'
gem 'riiif', '~> 1.1'

# Security update
gem 'rubyzip', '~> 1.3.0'

# Monitoring and Observability
gem 'honeycomb-beeline', '>= 2.10.0'
gem 'libhoney', '>= 2.2.0'

# Yabeda
gem 'yabeda'
gem 'yabeda-prometheus'
gem 'yabeda-sidekiq'
gem 'yabeda-rails'
gem 'yabeda-puma-plugin'
gem 'yabeda-http_requests'

# Pin rdf down because Hyrax has a superclass mismatch
# https://github.com/ruby-rdf/rdf/blob/3.2.5/lib/rdf/model/literal/datetime.rb#L7
# https://github.com/samvera/active_fedora/blob/v12.1.1/lib/active_fedora.rb#L16
gem 'rdf', '3.2.4'

group :development do
  gem 'listen', '~> 3.0.5'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # May not be supported in Ruby 3
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'debase', '>= 0.2.5.beta2'
  gem 'debase-ruby_core_source'
  gem 'fcrepo_wrapper'
  gem 'pry-rails'
  gem 'ruby-debug-ide'
  gem 'rspec-rails'
  gem 'solr_wrapper', '>= 0.3'
  gem 'rubocop', '>= 1.50.2'
  gem 'rubocop-rspec', '>= 2.20.0'
end

#group :staging, :production do
#  gem 'clamav'
#end

group :test do
  gem 'capybara'
  gem 'coveralls', '~> 0.8'
  gem 'database_cleaner', '~> 1.8.5'
  gem 'equivalent-xml'
  gem 'poltergeist'
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-mocks'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers', '~> 4'
  gem 'simplecov', '>= 0.9'
  gem 'webmock'
end
