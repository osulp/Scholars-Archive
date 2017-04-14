require 'mini_magick'

MiniMagick.configure do |config|
  config.whiny = true
  config.shell_api = "posix-spawn"
end
