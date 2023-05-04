module ScholarsArchive
  module EtdTerms
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
        time_required
        typical_age_range
        learning_resource_type
        interactivity_type
        is_based_on_url
        bibliographic_citation
        academic_affiliation
        other_affiliation
        in_series
        subject
        tableofcontents
        rights_statement]
    end
  end
end
