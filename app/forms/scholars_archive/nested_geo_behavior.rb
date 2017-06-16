module ScholarsArchive
  module NestedGeoBehavior
    extend ActiveSupport::Concern

    included do

      delegate :nested_geo_attributes=, :to => :model

      def initialize_fields
        model.nested_geo.build
        super
      end

    end
  end
end
