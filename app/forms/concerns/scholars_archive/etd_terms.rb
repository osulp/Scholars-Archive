# frozen_string_literal:true

module ScholarsArchive
  # Houses terms for ETDs
  module EtdTerms
    def self.base_terms
      primary_terms + secondary_terms + admin_terms
    end

    # rubocop:disable Metrics/MethodLength
    def self.primary_terms
      %i[nested_ordered_title
         nested_ordered_creator
         nested_ordered_contributor
         resource_type
         nested_ordered_abstract
         dates_section
         degree_level
         degree_name
         degree_field
         degree_grantors
         academic_affiliation
         other_affiliation
         graduation_year
         contributor_advisor
         contributor_committeemember
         license
         rights_statement
         nested_related_items
         subject
         accessibility_feature]
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def self.secondary_terms
      %i[bibliographic_citation
         funding_body
         funding_statement
         publisher
         peerreviewed
         conference_name
         conference_section
         conference_location
         geo_section
         hydrologic_unit_code
         language
         file_format
         file_extent
         digitization_spec
         nested_ordered_additional_information]
    end
    # rubocop:enable Metrics/MethodLength

    def self.admin_terms
      %i[in_series
         identifier
         is_referenced_by
         replaces
         keyword
         source
         dspace_community
         dspace_collection
         description
         documentation]
    end
  end
end
