class OerPresenter < DefaultWorkPresenter
  delegate :is_based_on_url, :interactivity_type, :learning_resource_type, :typical_age_range, :time_required, to: :solr_document
end
