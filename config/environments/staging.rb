require_relative 'production'

Rails.application.configure do
  config.action_mailer.default_url_options = { host: 'lib-saapp1.library.oregonstate.edu' }
end
