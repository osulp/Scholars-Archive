module ScholarsArchive
  module NestedRelatedBehavior
    extend ActiveSupport::Concern
    included do
      delegate :nested_related_items_attributes=, :to => :model
      def initialize_fields
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        puts model.nested_related_items.first
        model.nested_related_items.build({index:"0"})
        super
      end
    end
  end
end