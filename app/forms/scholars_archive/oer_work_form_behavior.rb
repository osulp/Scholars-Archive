# frozen_string_literal: true

module ScholarsArchive
  # form behavior for oer
  module OerWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += ScholarsArchive::OerTerms.base_terms

      def primary_terms
        ::ScholarsArchive::OerTerms.primary_terms
      end

      def secondary_terms
        t = ::ScholarsArchive::OerTerms.secondary_terms
        t << ::ScholarsArchive::OerTerms.admin_terms if current_ability.current_user.admin?
        t.flatten
      end
    end
  end
end
