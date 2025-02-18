# frozen_string_literal:true

module ScholarsArchive
  # Houses the terms for forms for ConferenceProceedingsOrJournals
  module ConferenceTerms
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
         conference_name
         conference_section
         conference_location
         editor
         has_journal
         has_volume
         has_number
         nested_related_items
         subject
         accessibility_feature]
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def self.secondary_terms
      %i[funding_body
         funding_statement
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
