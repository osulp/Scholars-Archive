Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Use Sidekiq for background jobs like ingest
  config.active_job.queue_adapter = ENV.fetch('ACTIVE_JOB_QUEUE_ADAPTER', 'inline').to_sym

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :mem_cache_store, ENV.fetch('RAILS_CACHE_STORE_URL', 'localhost')
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  config.action_mailer.perform_caching = false

  # Don't actually send emails in development
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.public_file_server.enabled = true

  config.assets.configure do |env|
    env.register_mime_type 'text/haml', extensions: ['.html']
    env.register_transformer 'text/haml', 'text/html', Tilt::HamlTemplate
    env.register_engine '.haml', Tilt::HamlTemplate
  end

  # Add new customize tags to append to log info
  config.log_tags = [
    :request_id,
    -> request { request.fullpath }
  ]

  # Add in setting to turn off color escape key
  config.colorize_logging = false

  # Add in new formatter to the already-exist Logger
  config.log_formatter = proc do |severity, datetime, progname, msg|
    # Setup the Logger to get info out of the string and remove any info that has been fetch out
    msg_vals = []
    item_arr = msg.split
    while item_arr[0].include?(']')
      msg_vals << item_arr[0].gsub(/[\[\]]+/, '')
      item_arr = item_arr[1..-1]
    end
    msg = item_arr.join(' ')

    # Format the whole log into JSON format
    %Q| {
         date: "#{datetime.to_s}",
         log_level: "#{severity.to_s}",
         req_id: "#{msg_vals[0]}",
         req_uri: "#{msg_vals[1]}",
         uri: "#{URI.regexp([/https?/]).match(msg).to_s.gsub(/[\)\(]*$/, '')}",
         message: "#{msg}",
         service_id: "#{msg.split("Service: ").last if msg.split("Service: ").count > 1}"
        }\n|
  end

  config.web_console.whitelisted_ips = ['172.0.0.0/8', '192.0.0.0/8']
end
