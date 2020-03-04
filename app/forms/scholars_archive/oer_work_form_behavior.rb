# frozen_string_literal: true

module ScholarsArchive
  # form behavior for oer
  module OerWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += model_class::OER_TERMS

      def primary_terms
        model_class::OER_PRIMARY_TERMS | super - %i[degree_level degree_name degree_field contributor_advisor]
      end

      def secondary_terms
        super - date_terms + [:duration]
      end
    end
  end
end
