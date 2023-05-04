# frozen_string_literal: true

module ScholarsArchive
  # Form behavior for article
  module ArticleWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += ::ScholarsArchive::ArticleTerms.base_terms

      def primary_terms
        ::ScholarsArchive::ArticleTerms.primary_terms | super - %i[degree_level degree_name degree_field contributor_advisor]
      end

      def secondary_terms
        t = super - date_terms - %i[conference_location conference_name conference_section]
        t << :web_of_science_uid if current_ability.current_user.admin?
        t
      end
    end
  end
end
