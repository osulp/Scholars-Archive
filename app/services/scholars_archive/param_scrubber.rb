# frozen_string_literal: true

module ScholarsArchive
  # checks peer reviewed
  class ParamScrubber
    def self.scrub(params, hash_key)
      params[hash_key].each_pair do |attr, value|
        # If value is an array
        if value.is_a?(Array)
          value.map do |v|
            # Removes spaces from array based values
            strip_value(params[hash_key][attr.to_s], v)
          end
        # If value is a string
        elsif value.is_a? Hash
          # Recursively digs into hashes until proper value is found
          extract_hash_values(value)
        elsif value.is_a? String
          # Remove spaces from the params for single value fields
          strip_value(params[hash_key][attr.to_s], value)
        end
      end 
    end

    private

    def self.extract_hash_values(hash)
      hash.each_pair do |key, value|
        if value.respond_to?(:strip)
          return strip_value(hash[key], value)
        else
          extract_hash_values(value)
        end
      end
    end

    def self.strip_value(attribute, value)
      attribute = value.strip unless value.nil? || value.frozen?
    end
  end
end

