# frozen_string_literal:true

module ScholarsArchive
  # Houses the terms for Datasets
  module DatasetTerms
    # rubocop:disable Metrics/MethodLength
    def self.base_terms
      primary_terms + ::ScholarsArchive::DefaultTerms.date_terms + admin_terms +
        %i[nested_related_items
           date_uploaded
           date_modified
           tableofcontents
           file_extent
           file_format
           dspace_community
           dspace_collection
           isbn
           issn
           embargo_reason
           human_data]
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def self.primary_terms
      %i[nested_ordered_title
         alternative_title
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
         funding_body
         funding_statement
         publisher
         peerreviewed
         language
         digitization_spec
         replaces
         nested_ordered_additional_information
         accessibility_feature
         accessibility_summary]
    end
    # rubocop:enable Metrics/MethodLength

    def self.admin_terms
      %i[documentation]
    end
  end
end
