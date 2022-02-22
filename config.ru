# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# Start the prometheus exporter before Rails
use Yabeda::Prometheus::Exporter

run Rails.application
