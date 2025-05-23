# frozen_string_literal: true

module ScholarsArchive
  # triple powered resource for PER
  module HasPurchasedEResourceTriplePoweredProperties
    extend ActiveSupport::Concern
    extend ScholarsArchive::HasEtdTriplePoweredProperties

    included do
      def triple_powered_properties
        [{ field: :other_affiliation, has_date: true, skip_validation: true }, { field: :degree_field, has_date: false, skip_validation: true }, { field: :degree_grantors, has_date: false, skip_validation: true }]
      end
    end
  end
end
