require 'net/http'

module ScholarsArchive
  class CachingService

    def self.fetch_or_store_in_cache(uri, expires_in)
      check_cached_etag(uri, expires_in)
    end

    private
      def self.check_cached_etag(uri, expires_in)
        etag = fetch_etag(uri)
        data = Rails.cache.read(uri+"_etag")
        json = nil
        if data.nil? || data != etag
          cache_etag(uri, etag, expires_in)
          json = fetch_json(uri)
          cache_json(uri, json, expires_in)
        else
          json = fetch_json_from_cache(uri)
        end
        json
      end

      def self.fetch_etag(uri)
        url = URI.parse(uri.to_s)
        req = Net::HTTP::Head.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) do |http|
          http.request(req)
        end
        res["etag"]
      end

      def self.fetch_json_from_cache(uri)
        Rails.cache.read(uri)
      end

      def self.cache_etag(uri, etag, expires_in)
        Rails.cache.write(uri+"_etag", etag, expires_in: expires_in.to_i.hours, race_condition_ttl: 15.seconds)
      end

      def self.cache_json(uri, json, expires_in)
        Rails.cache.write(uri, json, expires_in: expires_in.to_i.hours, race_condition_ttl: 15.seconds)
      end

      def self.fetch_json(uri)
        url = URI.parse(uri.to_s)
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) do |http|
          http.request(req)
        end
        res.body
      end
  end
end
