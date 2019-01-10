# frozen_string_literal: true

module ScholarsArchive
  # Cache based authority for QA
  class CacheBasedAuthority < Qa::Authorities::Local::FileBasedAuthority
    private

      def terms
        authority_yaml = YAML.load(File.read(subauthority_filename))
        uri = authority_yaml.with_indifferent_access.dig(@subauthority, :uri)
        expiration = authority_yaml.with_indifferent_access.dig(@subauthority, :cache_expires_in_hours)
        raise "#{@subauthority} uri configuration not found. " unless uri
        raise '#cache_expires_in configuration not found. ' unless expiration
        result = ScholarsArchive::CachingService.fetch_or_store_in_cache(uri, expiration)
        parser = authority_yaml.with_indifferent_access.dig(@subauthority, :parser)
        raise "#{@subauthority} Parser configuration not found. " unless parser
        parser = parser.constantize
        parser.parse(result) #return the properly shaped data
      end

      def subauthority_filename
        File.join(Rails.root, 'config/authorities.yml')
      end
  end
end
