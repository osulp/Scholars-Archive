module ScholarsArchive
  module HasTriplePoweredProperties
    extend ActiveSupport::Concern

    included do

      self.validates_with ScholarsArchive::TriplePoweredProperties::HasUrlValidator

      class_attribute :triple_powered_properties

      def triple_powered_properties
        [:academic_affiliation, :other_affiliation]
      end
    end
  end
end
