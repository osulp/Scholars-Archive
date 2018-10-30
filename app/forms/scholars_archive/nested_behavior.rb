module ScholarsArchive
  module NestedBehavior
    extend ActiveSupport::Concern

    included do

      delegate :nested_geo_attributes=, :to => :model
      delegate :nested_related_items_attributes=, :to => :model
      delegate :nested_ordered_creator_attributes=, :to => :model
      delegate :nested_ordered_contributor_attributes=, :to => :model
      delegate :nested_ordered_additional_information_attributes=, :to => :model
      delegate :nested_ordered_abstract_attributes=, :to => :model
      delegate :nested_ordered_title_attributes=, :to => :model


      def initialize_fields
        model.nested_geo.build
        model.nested_related_items.build({index:"0"})
        model.nested_ordered_creator.build({index:"0"})
        model.nested_ordered_title.build({index:"0"})
        model.nested_ordered_abstract.build({index:"0"})
        model.nested_ordered_contributor.build({index:"0"})
        model.nested_ordered_additional_information.build({index:"0"})
        super
      end

    end
  end
end
