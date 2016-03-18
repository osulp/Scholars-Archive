require_relative 'production'

Rails.application.configure do
  config.action_mailer.default_url_options = { host: 'lib-saapp1.library.oregonstate.edu' }

  # Rotate logs in a something a bit more sane and sensitive to disk fillage,
  # the second argument is how many to keep in rotation, and the third argument
  # is the size of the log before it is rotated
  config.logger = Logger.new(Rails.root.join('log', "#{Rails.env}.log"), 10, 1.megabytes)
end
