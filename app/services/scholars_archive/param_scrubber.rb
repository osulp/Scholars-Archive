# frozen_string_literal: true

module ScholarsArchive
  # checks peer reviewed
  class ParamScrubber
    def self.scrub(params, hash_key)
      params[hash_key].each_pair do |attr, value|
        if value.is_a?(Array)
          value.map do |v|
            # Removes spaces from array based values
            v.strip unless v.nil? || v.frozen?
          end
        # If value is a Hash
        elsif value.is_a? ActionController::Parameters
          # Recursively digs into hashes until proper value is found
          params[hash_key][attr.to_s] = extract_hash_values(value.to_hash).to_hash
        elsif value.is_a? String
          # Remove spaces from the params for single value fields
          params[hash_key][attr.to_s] = value.strip unless value.nil? || value.frozen?
        end
      end
    end

    private

    def self.extract_hash_values(hash)
      hash.each_pair do |key, value|
        if value.respond_to?(:strip)
          return hash[key] = value.strip unless value.nil? || value.frozen?
        else
          extract_hash_values(value)
        end
      end
    end
  end
end

