module ScholarsArchive
  module NestedBehavior
    extend ActiveSupport::Concern

    included do

      delegate :nested_geo_attributes=, :to => :model
      delegate :nested_related_items_attributes=, :to => :model
      delegate :nested_ordered_creator_attributes=, :to => :model

      def initialize_fields
        model.nested_geo.build
        model.nested_related_items.build
        model.nested_ordered_creator.build
        super
      end

    end
  end
end
