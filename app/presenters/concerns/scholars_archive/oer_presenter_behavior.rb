module ScholarsArchive
  module OerPresenterBehavior
    extend ActiveSupport::Concern
    included do
      delegate :interactivity_type,
               :is_based_on_url,
               :learning_resource_type,
               :time_required,
               :nested_ordered_typical_age_range,
               :nested_ordered_typical_age_range_label,
               :duration,  to: :solr_document
    end
  end
end
