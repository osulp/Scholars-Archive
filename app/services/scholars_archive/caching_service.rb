# frozen_string_literal: true

require 'net/http'

module ScholarsArchive
  class CachingService
    def self.fetch_or_store_in_cache(uri, expires_in)
      fetch_or_cache_json_from_etag(uri, expires_in)
    end

    private
      def self.fetch_or_cache_json_from_etag(uri, expires_in)
        etag = fetch_etag(uri)
        data = read_etag_from_cache(uri)
        json = nil
        if data.nil? || data != etag
          json_response = fetch_json_and_etag(uri)
          json = json_response.body
          etag = json_response['etag']
          cache_json(uri, json, expires_in)
          cache_etag(uri, etag, expires_in)
        else
          json = read_json_from_cache(uri)
        end
        json
      end

      def self.fetch_etag(uri)
        fetch(uri, Net::HTTP::Head, 'etag')
      end

      def self.fetch_json_and_etag(uri)
        fetch(uri, Net::HTTP::Get, 'full response')
      end

      def self.read_etag_from_cache(uri)
        read(uri+'_etag')
      end

      def self.read_json_from_cache(uri)
        read(uri)
      end

      def self.cache_etag(uri, payload, expires_in)
        cache(uri+'_etag', payload, expires_in)
      end

      def self.cache_json(uri, payload, expires_in)
        cache(uri, payload, expires_in)
      end

      def self.fetch(uri, request_protocol, payload_type)
        payload = nil
        url = URI.parse(uri.to_s)
        req = request_protocol.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) do |http|
          http.request(req)
        end
        payload = res['etag'] if payload_type == 'etag'
        payload = res if payload_type == 'full response'
        payload
      end

      def self.read(uri)
        Rails.cache.read(uri)
      end

      def self.cache(uri, payload, expires_in)
        Rails.cache.write(uri, payload, expires_in: expires_in.to_i.hours, race_condition_ttl: 15.seconds)
      end
  end
end
