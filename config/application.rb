require_relative 'boot'

require 'rails/all'
require 'edtf'
require 'triplestore_adapter'
require 'blacklight_range_limit'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ScholarsArchive
  class Application < Rails::Application

    # The compile method (default in tinymce-rails 4.5.2) doesn't work when also
    # using tinymce-rails-imageupload, so revert to the :copy method
    # https://github.com/spohlenz/tinymce-rails/issues/183
    config.tinymce.install = :copy
    config.generators do |g|
      g.test_framework :rspec, :spec => true
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Pacific Time (US & Canada)'
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths += %W(#{config.root}/lib)

    # load and inject local_env.yml key/values into ENV
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    #Allows for the application to use classes in
    #lib/scholars_archive/triple_powered_properties
    config.enable_dependency_loading = true
    config.autoload_paths << Rails.root.join('lib')

    config.rubycas.cas_base_url = ENV["SCHOLARSARCHIVE_CAS_BASE_URL"] || 'https://cas.myorganization.com'
    config.to_prepare  do
      Hyrax::CurationConcern.actor_factory.insert_after(Hyrax::Actors::OptimisticLockValidator, ScholarsArchive::Actors::NestedFieldsOperationsActor)
      Hyrax::CurationConcern.actor_factory.insert_after(Hyrax::Actors::OptimisticLockValidator, ScholarsArchive::Actors::AddOtherFieldOptionActor)
    end

  end
end
