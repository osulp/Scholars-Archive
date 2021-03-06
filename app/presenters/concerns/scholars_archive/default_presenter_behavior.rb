# frozen_string_literal: true

module ScholarsArchive
  # presenter behavior for default
  module DefaultPresenterBehavior
    extend ActiveSupport::Concern
    included do
      delegate :abstract,
               :academic_affiliation_label,
               :alt_title,
               :based_near_linked,
               :bibliographic_citation,
               :conference_name,
               :conference_section,
               :conference_location,
               :contributor_advisor,
               :date_accepted,
               :date_available,
               :date_collected,
               :date_copyright,
               :date_issued,
               :date_valid,
               :date_reviewed,
               :degree_level,
               :degree_name,
               :degree_field,
               :degree_field_label,
               :digitization_spec,
               :doi,
               :dspace_collection,
               :dspace_community,
               :embargo_reason,
               :embargo_date_range,
               :file_extent,
               :file_format,
               :funding_body,
               :funding_statement,
               :hydrologic_unit_code,
               :in_series,
               :isbn,
               :issn,
               :itemtype,
               :language_label,
               :license,
               :license_label,
               :nested_geo,
               :nested_ordered_creator,
               :nested_ordered_creator_label,
               :nested_ordered_title,
               :nested_ordered_title_label,
               :nested_ordered_abstract,
               :nested_ordered_abstract_label,
               :nested_ordered_contributor,
               :nested_ordered_contributor_label,
               :nested_ordered_additional_information,
               :nested_ordered_additional_information_label,
               :nested_related_items,
               :nested_related_items_label,
               :other_affiliation_label,
               :peerreviewed_label,
               :replaces,
               :resource_type,
               :rights_statement_label,
               :tableofcontents, to: :solr_document
    end
  end
end
