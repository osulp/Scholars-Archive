module ScholarsArchive
  module NestedRelatedBehavior
    extend ActiveSupport::Concern
    included do
      delegate :nested_related_items_attributes=, :to => :model
      def initialize_fields
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        puts model.methods
        model.nested_related_items.build()
        super
      end
    end
  end
end