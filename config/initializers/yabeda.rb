# frozen_string_literal:true

# Configure the prometheus client to use direct file store
Prometheus::Client.config.data_store = Prometheus::Client::DataStores::DirectFileStore.new(dir: '/data/tmp/prom/prometheus_direct_file_store')

# Install the yabeda rails plugin
Yabeda::Rails.install!
