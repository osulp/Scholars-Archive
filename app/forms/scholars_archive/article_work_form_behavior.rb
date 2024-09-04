# frozen_string_literal: true

module ScholarsArchive
  # Form behavior for article
  module ArticleWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms = ::ScholarsArchive::ArticleTerms.base_terms + ::ScholarsArchive::DefaultTerms.base_terms

      def primary_terms
        ::ScholarsArchive::ArticleTerms.primary_terms
      end

      def secondary_terms
        t = ::ScholarsArchive::ArticleTerms.secondary_terms
        t << ::ScholarsArchive::ArticleTerms.admin_terms if current_ability.current_user.admin?
        t.flatten
      end
    end
  end
end
