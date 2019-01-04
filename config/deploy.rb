# frozen_string_literal: true

require 'yaml'
config = YAML.load_file('config/config.yml')['deployment'] || {}

# config valid only for current version of Capistrano
lock '3.8.2'

set :application, 'ScholarsArchive'
set :repo_url, config['repository']

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, config['deploy_to']

# The server must have rbenv installed and the version of ruby specified here.
set :rbenv_ruby, '2.5.1'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/local_env.yml', 'config/config.yml', 'config/initializers/hyrax.rb', 'config/analytics.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp', 'config/puma', 'public/assets', 'public/sitemap', 'public/branding'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :passenger_restart_with_touch, true

# tell monit to restart all defined processes (i.e. puma, sidekiq)
task :restart_monit do
  on roles(:app) do
    execute 'sudo /usr/bin/monit restart all'
  end
end
after 'deploy:published', 'restart_monit'

# Production and Staging environments are set to compile errors pages in the asset pipeline,
# and this task takes the most recent compiled error page and places it in the public/ path
namespace :deploy do
  desc 'Copy compiled error pages to public'
  task :copy_error_pages do
    on roles(:all) do
      %w[404 500].each do |page|
        page_glob = "#{current_path}/public/#{fetch(:assets_prefix)}/#{page}*.html"
        # copy newest asset
        asset_file = capture :ruby, %{-e "print Dir.glob('#{page_glob}').max_by { |file| File.mtime(file) }"}
        if asset_file
          execute :cp, "#{asset_file} #{current_path}/public/#{page}.html"
        else
          error "Error #{page} asset does not exist"
        end
      end
    end
  end
  after :finishing, :copy_error_pages
end
