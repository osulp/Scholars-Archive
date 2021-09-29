module OkComputer
  # Measure the latency of a sidekiq queue against some acceptable threshold measured in seconds
  # Latency == the difference between when the oldest job was pushed onto the queue versus the current time.
  # In other words, we want ingest jobs to run in < 5 minutes, and derivatives jobs to run in < 15 minutes.
  class SidekiqQueueLatencyCheck < OkComputer::Check
    def initialize(queue: :default, threshold: 60)
      @queue_name = queue
      @threshold = threshold
    end

    def check
      latency = Sidekiq::Queue.new(@queue_name).latency
      return unless latency > @threshold
      raise "Sidekiq queue #{@queue_name} has #{latency} seconds latency and expected less than #{@threshold}"
    end
  end
end
