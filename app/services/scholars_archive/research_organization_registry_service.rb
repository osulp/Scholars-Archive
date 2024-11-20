# frozen_string_literal: true

module ScholarsArchive
  # SERVICE: Add in class for ROR Service
  class ResearchOrganizationRegistryService < ::Qa::Authorities::ResearchOrganizationRegistry
    CACHE_KEY_PREFIX = 'scholars_archive_ror_label-v1-'
    CACHE_EXPIRATION = 1.week

    def full_label(uri)
      return if uri.blank?

      id = extract_id uri
      Rails.cache.fetch(cache_key(id), expires_in: CACHE_EXPIRATION) do
        search_term = search(id)
        return search_term.first['label']
      end
    rescue URI::InvalidURIError
      # Old data may be just a string, display it.
      uri
    end

    private

    def extract_id(obj)
      uri = case obj
            when String
              URI(obj)
            when URI
              obj
            else
              raise ArgumentError, "#{obj} is not a valid type"
            end
      uri.path.split('/').last
    end

    def cache_key(id)
      "#{CACHE_KEY_PREFIX}#{id}"
    end
  end
end
