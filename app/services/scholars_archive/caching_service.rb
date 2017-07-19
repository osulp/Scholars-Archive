require 'net/http'

module ScholarsArchive
  class CachingService
    def self.fetch_or_store_in_cache(uri, expires_in)
      Rails.cache.fetch(uri, expires_in: expires_in, race_condition_ttl: 15.seconds) do
        fetch_data(uri)
      end
    end

    private

      def self.fetch_data(uri)
        url = URI.parse(uri.to_s)
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) do |http|
          http.request(req)
        end
        res.body
      end
  end
end
