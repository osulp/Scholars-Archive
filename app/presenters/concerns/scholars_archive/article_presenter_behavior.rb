# frozen_string_literal: true

module ScholarsArchive
  # Presenter behavior for article
  module ArticlePresenterBehavior
    extend ActiveSupport::Concern
    included do
      delegate :conference_name,
               :conference_section,
               :conference_location,
               :editor,
               :has_journal,
               :has_number,
               :has_volume,
               :is_referenced_by,
               :web_of_science_uid, to: :solr_document
    end
  end
end
