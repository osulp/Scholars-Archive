# frozen_string_literal: true

# Initialize Honeycomb before everything else
require 'honeycomb-beeline'
Honeycomb.init

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application
