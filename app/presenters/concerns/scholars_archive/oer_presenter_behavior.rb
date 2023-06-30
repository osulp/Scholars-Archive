# frozen_string_literal: true

module ScholarsArchive
  # oer presenter behavior for show page
  module OerPresenterBehavior
    extend ActiveSupport::Concern
    included do
      delegate :interactivity_type,
               :is_based_on_url,
               :learning_resource_type,
               :time_required,
               :typical_age_range,
               :duration, to: :solr_document
    end
  end
end
