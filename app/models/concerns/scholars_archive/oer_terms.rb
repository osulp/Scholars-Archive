# frozen_string_literal: true

module ScholarsArchive
  # Includes dataset terms as singletons
  module OerTerms
    extend ActiveSupport::Concern
    included do
      OER_TERMS = %i[
        resource_type
        is_based_on_url
        interactivity_type
        learning_resource_type
        typical_age_range
        time_required
        duration
      ].freeze

      OER_PRIMARY_TERMS = %i[
        nested_ordered_title
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
        in_series subject
        tableofcontents
        rights_statement
      ].freeze
    end
  end
end
