# frozen_string_literal: true

module ScholarsArchive
  # triple powered properties
  module HasTriplePoweredProperties
    extend ActiveSupport::Concern

    included do
      validates_with ScholarsArchive::TriplePoweredProperties::HasUrlValidator

      class_attribute :triple_powered_properties

      def triple_powered_properties
        [{field: :academic_affiliation, has_date: false, skip_validation: false}, {field: :other_affiliation, has_date: false, skip_validation: false}, {field: :degree_field, has_date: false, skip_validation: false}]
      end
    end
  end
end
