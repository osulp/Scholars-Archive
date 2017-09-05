module ScholarsArchive
  module HasEtdTriplePoweredProperties
    extend ActiveSupport::Concern

    included do

      self.validates_with ScholarsArchive::TriplePoweredProperties::HasUrlValidator

      class_attribute :triple_powered_properties

      def triple_powered_properties
        [{field: :academic_affiliation, has_date: true}, {field: :other_affiliation, has_date: true}, {field: :degree_field, has_date: false}]
      end
    end
  end
end
