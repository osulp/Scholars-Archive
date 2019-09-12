# frozen_string_literal: true

if %w[production staging].include? Rails.env
  Datadog.configure do |c|
    c.use :rails, service_name: "scholars-archive-#{Rails.env}"
    c.use :http, service_name: "scholars-archive-#{Rails.env}-http"
    c.use :sidekiq, service_name: "scholars-archive-#{Rails.env}-sidekiq"
    c.use :redis, service_name: "scholars-archive-#{Rails.env}-redis"
  end
end