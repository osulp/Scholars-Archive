module ScholarsArchive
  module NestedBehavior
    extend ActiveSupport::Concern

    included do

      delegate :nested_geo_attributes=, :to => :model
      delegate :nested_related_items_attributes=, :to => :model
      delegate :nested_ordered_creator_attributes=, :to => :model
      delegate :nested_ordered_contributor_attributes=, :to => :model
      delegate :nested_ordered_description_attributes=, :to => :model
      delegate :nested_ordered_abstract_attributes=, :to => :model
      delegate :nested_ordered_title_attributes=, :to => :model


      def initialize_fields
        model.nested_geo.build
        model.nested_related_items.build
        model.nested_ordered_creator.build
        model.nested_ordered_title.build
        model.nested_ordered_abstract.build
        model.nested_ordered_contributor.build
        model.nested_ordered_description.build
        super
      end

    end
  end
end
