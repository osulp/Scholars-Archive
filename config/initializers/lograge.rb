# frozen_string_literal: true

if %w[development test].include? Rails.env
  Rails.application.configure do
    config.lograge.enabled = true
    
    config.lograge.keep_original_rails_log = true
    config.lograge.logger = ActiveSupport::Logger.new "#{Rails.root}/log/lograge-#{Rails.env}.log"
  end
end
