# frozen_string_literal: true

if %w[production staging].include? Rails.env
  Datadog.configure do |c|
    c.use :rails, service_name: "scholars-archive-#{Rails.env}"
  end
end
