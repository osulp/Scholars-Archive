# frozen_string_literal: true

module ScholarsArchive
  # checks peer reviewed
  class ParamScrubber
    def self.scrub(params, hash_key)
      params[hash_key].each_pair do |attr, value|
        if value.is_a?(Array)
          # Set the mapped array on the params hash
          set_values(params, hash_key, attr, mapped_values(value))

          # If value is a Hash
        elsif value.is_a? ActionController::Parameters
          # Recursively dig into the hashes
          # find the raw value and set them on the params hash
          set_values(params, hash_key, attr, extract_hash_values(value.to_hash).to_hash)
        elsif value.is_a? String
          # set the stripped string on the params
          set_params(params, hash_key, attr, value)
        end
      end
    end

    def self.extract_hash_values(hash)
      hash.each_pair do |key, value|
        return strip_and_set(hash, key, value) if value.respond_to?(:strip)

        extract_hash_values(value)
      end
    end

    # Map and strip the values on the array
    def self.mapped_values(value)
      return value.map { |val| val.each_pair { |k, v| strip_and_set(val, k, v) } } if value.first.is_a? ActionController::Parameters

      value.map { |v| v.strip unless v.nil? || v.frozen? }
    end

    # Three different ways to set properties
    # First is a stripped value on the params object
    def self.set_params(params, hash_key, attr, value)
      params[hash_key][attr.to_s] = value.strip unless value.nil? || value.frozen?
    end

    # Second is a hash within the parmas object
    def self.strip_and_set(hash, key, value)
      hash[key] = value.strip unless value.nil? || value.frozen?
    end

    # Last is setting a raw value on the params object
    def self.set_values(params, hash_key, attr, value)
      params[hash_key][attr.to_s] = value
    end
  end
end
