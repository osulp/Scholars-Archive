# frozen_string_literal: true

# TODO: fix the SmtpCheck
#class SmtpCheck < OkComputer::Check
#  def check
#    smtp = Net::SMTP.new ENV['SCHOLARSARCHIVE_SMTP_HOST'], ENV['SCHOLARSARCHIVE_SMTP_PORT']
#    smtp.start(ENV['SCHOLARSARCHIVE_SMTP_HOST'], ENV['SCHOLARSARCHIVE_SMTP_PORT'], :plain) do |s|
#      mark_message "SMTP connection working"
#    end
#  rescue => exception
#    mark_failure
#    mark_message "Cannot connect to SMTP"
#  end
#end

#OkComputer::Registry.register "smtp",     SmtpCheck.new

# Monitor :ingest and :default for slow jobs. Fail when the latest job in
#   each queue has been running for more than threshold seconds (300)
OkComputer::Registry.register 'ingest_queue', OkComputer::SidekiqQueueLatencyCheck.new(queue: :ingest, threshold: 300)
OkComputer::Registry.register 'default_queue', OkComputer::SidekiqQueueLatencyCheck.new(queue: Hyrax.config.ingest_queue_name.to_sym, threshold: 300)
