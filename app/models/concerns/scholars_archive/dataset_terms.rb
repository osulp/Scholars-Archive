# frozen_string_literal: true

module ScholarsArchive
  # Includes dataset terms as singletons
  module DatasetTerms
    extend ActiveSupport::Concern
    included do

      DATASET_TERMS = %i[
        nested_related_items
        date_uploaded
        date_modified
        doi
        other_affiliation
        academic_affiliation
        alt_title
        nested_ordered_abstract
        license
        resource_type
        date_available
        date_copyright
        date_issued
        date_collected
        date_valid
        date_reviewed
        date_accepted
        replaces
        nested_geo
        hydrologic_unit_code
        funding_body
        funding_statement
        in_series
        tableofcontents
        bibliographic_citation
        peerreviewed
        nested_ordered_additional_information
        digitization_spec
        file_extent
        file_format
        dspace_community
        dspace_collection
        isbn
        issn
        embargo_reason
      ].freeze

      DATASET_PRIMARY_TERMS = %i[
        nested_ordered_title
        alt_title
        nested_ordered_creator
        academic_affiliation
        other_affiliation
        nested_ordered_contributor
        nested_ordered_abstract
        license
        resource_type
        doi
        dates_section
        bibliographic_citation
        in_series
        subject
        rights_statement
        nested_related_items
        hydrologic_unit_code
        geo_section
        funding_statement
        publisher
        peerreviewed
        language
        digitization_spec
        replaces
        nested_ordered_additional_information
      ].freeze
    end
  end
end
