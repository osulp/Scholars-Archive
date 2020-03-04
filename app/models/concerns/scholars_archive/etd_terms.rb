# frozen_string_literal: true

module ScholarsArchive
  # Includes dataset terms as singletons
  module EtdTerms
    extend ActiveSupport::Concern
    included do
      ETD_TERMS = %i[
        degree_grantors
        contributor_committeemember
        graduation_year
        degree_discipline
      ].freeze

      ETD_PRIMARY_TERMS = %i[
        nested_ordered_title
        alt_title
        nested_ordered_creator
        nested_ordered_contributor
        nested_ordered_abstract
        license
        resource_type
        doi dates_section
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
    end
  end
end
