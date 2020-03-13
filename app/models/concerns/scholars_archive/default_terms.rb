# frozen_string_literal: true

module ScholarsArchive
  # Includes term singletons on default
  module DefaultTerms
    extend ActiveSupport::Concern
    included do
      DEFAULT_TERMS = %i[
        nested_related_items
        nested_ordered_creator
        nested_ordered_title
        nested_ordered_abstract
        nested_ordered_additional_information
        nested_ordered_contributor
        date_uploaded date_modified
        doi other_affiliation
        academic_affiliation
        alt_title license
        resource_type
        date_available
        date_copyright
        date_issued
        date_collected
        date_valid
        date_reviewed
        date_accepted
        degree_level
        degree_name
        degree_field
        replaces
        nested_geo
        hydrologic_unit_code
        funding_body
        funding_statement
        in_series
        tableofcontents
        bibliographic_citation
        peerreviewed
        digitization_spec
        file_extent
        file_format
        dspace_community
        dspace_collection
        isbn
        issn
        embargo_reason
        conference_name
        conference_section
        conference_location
        contributor_advisor
      ].freeze

      DEFAULT_PRIMARY_TERMS = %i[
        nested_ordered_title
        alt_title
        nested_ordered_creator
        nested_ordered_contributor
        contributor_advisor
        nested_ordered_abstract
        license
        resource_type
        doi
        dates_section
        degree_level
        degree_name
        degree_field
        bibliographic_citation
        academic_affiliation
        other_affiliation
        in_series
        subject
        tableofcontents
        rights_statement
      ].freeze

      DEFAULT_SECONDARY_TERMS = %i[
        nested_related_items
        hydrologic_unit_code
        geo_section
        funding_statement
        publisher
        peerreviewed
        conference_name
        conference_section
        conference_location
        language
        file_format
        file_extent
        digitization_spec
        replaces
        nested_ordered_additional_information
        isbn
        issn
      ].freeze

      DEFAULT_SECONDARY_ADMIN_TERMS = %i[
        nested_related_items
        hydrologic_unit_code
        geo_section
        funding_statement
        publisher
        peerreviewed
        conference_name
        conference_section
        conference_location
        language
        file_format
        file_extent
        digitization_spec
        replaces
        nested_ordered_additional_information
        isbn
        issn
        keyword
        source
        funding_body
        dspace_community
        dspace_collection
        description
        identifier
      ].freeze
    end
  end
end
