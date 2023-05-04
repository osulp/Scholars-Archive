#frozen_string_literal:true

module ScholarsArchive
  # Houses terms for ETDs
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
         in_series subject
         tableofcontents
         rights_statement]
    end
  end
end
