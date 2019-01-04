# frozen_string_literal: true

require 'mini_magick'
MiniMagick.logger.level = Logger::DEBUG
MiniMagick.configure do |config|
  config.whiny = true
  config.shell_api = 'posix-spawn'
end
