# frozen_string_literal: true

module ScholarsArchive
  # SERVICE: Add in class for Academic Affiliation Service
  class AcademicAffiliationService < ::Qa::Authorities::AcademicAffiliation
    CACHE_KEY_PREFIX = 'scholars_archive_academic_affiliation_label-v1-'
    CACHE_EXPIRATION = 1.week

    # All method follow the exact same layout on how Hyrax::LocationService works
    def full_label(uri)
      return if uri.blank?

      id = extract_id uri
      Rails.cache.fetch(cache_key(id), expires_in: CACHE_EXPIRATION) do
        label.call(find(id))
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
