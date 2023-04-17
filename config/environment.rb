# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Adding in hierarchy of config for PROD, DEV, and STAG
Rails.application.configure do
  # Add new customize tags to append to log info such as REQ_ID & REQ_URI
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
        "date": "#{datetime.to_s}",
        "log_level": "#{severity.to_s}",
        "req_id": "#{msg_vals[0]}",
        "req_uri": "#{msg_vals[1]}",
        "uri": "#{URI.regexp([/https?/]).match(msg).to_s.gsub(/[\)\(]*$/, '')}",
        "message": "#{msg}",
        "service_id": "#{msg.split("Service: ").last if msg.split("Service: ").count > 1}"
        }\n|
  end
end
