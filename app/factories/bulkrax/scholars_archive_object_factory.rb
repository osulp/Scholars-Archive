# frozen_string_literal: true

module Bulkrax
  # Object factory
  class ScholarsArchiveObjectFactory < ObjectFactory
    # Override to add the _attributes properties
    def permitted_attributes
      attribute_properties + super
    end

    # Gather the attribute_properties
    def attribute_properties
      klass.properties.keys.map { |k| "#{k}_attributes".to_sym if klass.properties[k].class_name&.to_s&.include? 'Nested' }.compact
    end
  end
end
