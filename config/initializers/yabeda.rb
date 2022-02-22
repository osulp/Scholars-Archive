# Yabeda metrics integration

# ENV:
#   YABEDA_SIDEKIQ_COLLECT_CLUSTER_METRICS: true
#   YABEDA_DEBUG: true
#   PROMETHEUS_EXPORTER_URL: "tcp://0.0.0.0:9395/metrics"
#   PROMETHEUS_EXPORTER_BIND: 0.0.0.0
#   PROMETHEUS_EXPORTER_PATH: /metrics
#   PROMETHEUS_EXPORTER_PORT: 9395

### Add metrics endpoint for Sidekiq
#Sidekiq.configure_server do |_config|
#  Yabeda::Prometheus::Exporter.start_metrics_server! logger: Rails.application.logger
#end

### Add metrics endpoint for Rails, before Rails is executed in config.ru
# use Yabeda::Prometheus::Exporter

# Use the DirectFileStore for Prometheus::Client
# needed to support multi-threaded and multi-process metrics
Prometheus::Client.config.data_store = Prometheus::Client::DataStores::DirectFileStore.new(dir: '/tmp/prometheus_direct_file_store')
