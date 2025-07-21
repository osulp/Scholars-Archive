# frozen_string_literal: true

module ScholarsArchive
  # sets triple powered properties
  module HasEtdTriplePoweredProperties
    extend ActiveSupport::Concern

    included do
      validates_with ScholarsArchive::TriplePoweredProperties::HasUrlValidator

      class_attribute :triple_powered_properties

      def triple_powered_properties
        [{ field: :academic_affiliation, has_date: false, skip_validation: false }, { field: :other_affiliation, has_date: false, skip_validation: false }, { field: :degree_field, has_date: false, skip_validation: false }, { field: :degree_grantors, has_date: false, skip_validation: false }]
      end
    end
  end
end
