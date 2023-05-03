# frozen_string_literal: true

module ScholarsArchive
  # form behavior for oer
  module OerWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += %i[resource_type is_based_on_url interactivity_type learning_resource_type typical_age_range time_required duration]

      def primary_terms
        ::ScholarsArchive::OerTerms.primary_terms | super - %i[degree_level degree_name degree_field contributor_advisor]
      end

      def secondary_terms
        super - date_terms + [:duration]
      end
    end
  end
end
