#frozen_string_literal:true

module ScholarsArchive
  # Houses the terms for forms for articles
  module ArticleTerms
    def self.base_terms
      %i[resource_type
        editor
        has_volume
        has_number
        conference_location
        conference_name
        conference_section
        has_journal
        is_referenced_by
        web_of_science_uid]
    end

    def self.primary_terms
      %i[nested_ordered_title
        alt_title
        nested_ordered_creator
        nested_ordered_contributor
        nested_ordered_abstract
        license
        resource_type
        doi
        dates_section
        bibliographic_citation
        is_referenced_by
        has_journal
        has_volume
        has_number
        conference_name
        conference_section
        conference_location
        editor
        academic_affiliation
        other_affiliation
        in_series
        subject
        tableofcontents
        rights_statement]
    end
  end
end
