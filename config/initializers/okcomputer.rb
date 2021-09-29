# frozen_string_literal: true

class SmtpCheck < OkComputer::Check
  def check
    smtp = Net::SMTP.new ENV['SCHOLARSARCHIVE_SMTP_HOST'], ENV['SCHOLARSARCHIVE_SMTP_PORT']
    smtp.start(ENV['SCHOLARSARCHIVE_SMTP_HOST'], ENV['SCHOLARSARCHIVE_SMTP_PORT'], :plain) do |s|
      mark_message "SMTP connection working"
    end
  rescue => exception
    mark_failure
    mark_message "Cannot connect to SMTP"
  end
end

OkComputer::Registry.register "smtp",     SmtpCheck.new

# Measure the latency of a sidekiq queue against some acceptable threshold measured in seconds
# Latency == the difference between when the oldest job was pushed onto the queue versus the current time.
# In other words, we want ingest jobs to run in < 5 minutes, and derivatives jobs to run in < 15 minutes.
OkComputer::Registry.register 'ingest_queue', OkComputer::SidekiqQueueLatencyCheck.new(queue: :ingest, threshold: 300)
OkComputer::Registry.register 'default_queue', OkComputer::SidekiqQueueLatencyCheck.new(queue: Hyrax.config.ingest_queue_name.to_sym, threshold: 300)
