# frozen_string_literal: true

module ScholarsArchive
  # Behavior for bot detection and allow-listing of IP addresses.
  module BotDetectionBehavior
    extend ActiveSupport::Concern

    # 'ir.library.oregonstate.edu,ir-staging.library.oregonstate.edu,test.lib.oregonstate.edu:3000'
    def valid_bot?
      ENV.fetch('URI_TURNSTILE_BYPASS', '').split(',').include?(request.domain) || allow_listed_ip_addr?
    end

    def allow_listed_ip_addr?
      ips = ENV.fetch('IP_TURNSTILE_BYPASS', '') # '127.0.0.1-127.255.255.255,66.249.64.0-66.249.79.255'
      ranges = ips.split(',')
      ranges.each do |range|
        range = range.split('-')
        range = (IPAddr.new(range[0]).to_i..IPAddr.new(range[1]).to_i)
        return true if range.include?(IPAddr.new(request.remote_ip).to_i)
      end
      false
    end
  end
end
