# frozen_string_literal:true

module ScholarsArchive
  # Houses the terms for forms for articles
  module ArticleTerms
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
         funding_statement
         license
         rights_statement
         bibliographic_citation
         dates_section
         has_journal
         has_volume
         has_number
         publisher
         peerreviewed
         nested_related_items
         subject
        ]
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def self.secondary_terms
      %i[in_series
         funding_body
         conference_name
         conference_section
         conference_location
         editor
         issn
         isbn
         web_of_science_uid
         tableofcontents
         geo_section
         hydrologic_unit_code
         language
         file_format
         file_extent
         digitization_spec
         nested_ordered_additional_information
        ]
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def self.admin_terms
      %i[identifier
         is_referenced_by
         replaces
         keyword
         source
         dspace_community
         dspace_collection
         description
         documentation
        ]
    end
    # rubocop:enable Metrics/MethodLength
  end
end
