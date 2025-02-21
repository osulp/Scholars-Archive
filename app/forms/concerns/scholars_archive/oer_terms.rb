# frozen_string_literal:true

module ScholarsArchive
  # Houses terms for OERs
  module OerTerms
    def self.base_terms
      primary_terms + secondary_terms + admin_terms
    end

    # rubocop:disable Metrics/MethodLength
    def self.primary_terms
      %i[nested_ordered_title
         alternative_title
         nested_ordered_creator
         nested_ordered_contributor
         resource_type
         nested_ordered_abstract
         doi
         academic_affiliation
         other_affiliation
         license
         rights_statement
         bibliographic_citation
         dates_section
         publisher
         peerreviewed
         in_series
         nested_related_items
         subject
         learning_resource_type
         interactivity_type
         time_required
         typical_age_range
         is_based_on_url
         accessibility_feature
         accessibility_summary]
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def self.secondary_terms
      %i[funding_body
         funding_statement
         conference_name
         conference_section
         conference_location
         issn
         isbn
         tableofcontents
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
      %i[identifier
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
