# frozen_string_literal:true

module ScholarsArchive
  # Houses terms for Defaults
  module DefaultTerms
    def self.base_terms
      primary_terms + secondary_terms + admin_terms + date_terms +
        %i[date_uploaded
           date_modified
           nested_geo
           file_format
           embargo_reason]
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
         degree_level
         degree_name
         degree_field
         contributor_advisor
         license
         rights_statement
         bibliographic_citation
         dates_section
         publisher
         peerreviewed
         in_series
         nested_related_items
         subject
         accessibility_feature]
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

    def self.date_terms
      %i[date_available
         date_copyright
         date_issued
         date_collected
         date_valid
         date_reviewed
         date_accepted]
    end
  end
end
