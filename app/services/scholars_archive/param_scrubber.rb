# frozen_string_literal: true

module ScholarsArchive
  # checks peer reviewed
  class ParamScrubber
    def self.scrub(params, hash_key)
      params[hash_key].each_pair do |attr, value|
        if value.is_a?(Array)
          set_param_array(params, hash_key, attr, map_array(value))
        # If value is a Hash
        elsif value.is_a? ActionController::Parameters
          # Recursively digs into hashes until proper value is found
          # set_param_value(params[hash_key][attr.to_s], extract_hash_values(value.to_hash).to_hash)
          extract_hash_values(params, hash_key, attr, value.to_hash).to_hash
        elsif value.is_a? String
          # Remove spaces from the params for single value fields
          set_param_value(params, hash_key, attr, value)
        end
      end
    end

    private

    def self.extract_hash_values(params, hash_key, attr, hash)
      hash.each_pair do |key, value|
        if value.respond_to?(:strip)
          return set_param_value(params, hash_key, attr, value)
        else
          extract_hash_values(params, hash_key, attr, value)
        end
      end
    end

    def self.set_param_value(params, hash_key, attr, value)
      params[hash_key][attr.to_s] = value.strip unless value.nil? || value.frozen? 
    end

    def self.set_param_array(params, hash_key, attr, value)
      params[hash_key][attr.to_s] = value 
    end

    def self.map_array(value)
      value.map do |v|
        # Removes spaces from array based values
        v.strip unless v.nil? || v.frozen?
      end 
    end
  end
end
