require 'yaml'
config = YAML.load_file('config/config.yml')["deployment"] || {}

# config valid only for current version of Capistrano
lock '3.8.2'

set :application, 'ScholarsArchive'
set :repo_url, config['repository']

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, config['deploy_to']

# The server must have rbenv installed and the version of ruby specified here.
set :rbenv_ruby, '2.3.1'

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
append :linked_dirs, 'log', 'tmp', 'config/puma', 'public/assets'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :passenger_restart_with_touch, true

# tell monit to restart all defined processes (i.e. puma, sidekiq)
task :restart_monit do
  on roles(:app) do
    execute "sudo /usr/bin/monit restart all"
  end
end
after "deploy:published", "restart_monit"
