module ScholarsArchive
  module NestedBehavior
    extend ActiveSupport::Concern

    included do
      # Dunno if this is gonna work
      lambda { |nested_models=nested_models| nested_models.each { |model| delegate "%s_attributes=" % model, to: :model}
      # delegate :nested_geo_attributes=, :to => :model
      # delegate :nested_related_items_attributes=, :to => :model
      # delegate :nested_ordered_creator_attributes=, :to => :model
      # delegate :nested_ordered_title_attributes=, :to => :model

      def initialize_fields
        nested_models.each { |nested| model.call(nested).build }
        super
      end

      def nested_models
        [:nested_geo, :nested_related_items, :nested_ordered_creator, :nested_ordered_title]
      end
    end
  end
end
