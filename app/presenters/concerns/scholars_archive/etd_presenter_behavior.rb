# frozen_string_literal: true

module ScholarsArchive
  # etd presenter for show page
  module EtdPresenterBehavior
    extend ActiveSupport::Concern
    included do
      delegate :contributor_committeemember,
               :degree_discipline,
               :degree_field,
               :degree_field_label,
               :degree_grantors,
               :degree_grantors_label,
               :degree_level,
               :degree_name,
               :graduation_year, to: :solr_document
    end
  end
end
