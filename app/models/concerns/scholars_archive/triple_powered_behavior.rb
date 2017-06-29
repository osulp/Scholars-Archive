module ScholarsArchive
  module TriplePoweredBehavior
    extend ActiveSupport::Concern

    included do
      self.validates_with ScholarsArchive::TriplePoweredProperties::HasUrlValidator

      def triple_powered_properties
        [:academic_affiliation, :other_affiliation]
      end
    end
  end
end
