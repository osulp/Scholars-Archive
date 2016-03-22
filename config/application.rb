require File.expand_path('../boot', __FILE__)

require 'rails/all'
require_relative '../lib/scholars_archive'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
module ScholarsArchive
  class Application < Rails::Application
    ::APPLICATION_CONFIG = YAML.load(ERB.new(File.read(Rails.root.join('config/config.yml'))).result) || {}

    config.generators do |g|
      g.test_framework :rspec, :spec => true
    end

    # Configure CAS
    config.rubycas.cas_base_url = APPLICATION_CONFIG["rubycas"]["cas_base_url"]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    #
    # Web Console line for running tests
    config.web_console.development_only = false

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.autoload_paths += %W(#{config.root}/lib)
    config.active_record.raise_in_transactional_callbacks = true

    config.action_mailer.default_url_options = { :host => APPLICATION_CONFIG["notifications"]["url_host"] }
  end
end
