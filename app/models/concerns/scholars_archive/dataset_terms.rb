# frozen_string_literal: true

module ScholarsArchive
  # Includes dataset terms as singletons
  module DatasetTerms
    extend ActiveSupport::Concern
    included do
      DATASET_TERMS = %i[
        nested_ordered_title
        alt_title
        nested_ordered_creator
        nested_ordered_contributor
        nested_ordered_abstract
        license
        resource_type
        doi
        dates_section
        degree_level
        degree_name
        degree_field
        degree_grantors
        graduation_year
        contributor_advisor
        contributor_committeemember
        bibliographic_citation
        academic_affiliation
        other_affiliation
        in_series
        subject
        tableofcontents
        rights_statement
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
