# frozen_string_literal: true

module ScholarsArchive
  # Form behavior for article
  module ArticleWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += Article.article_properties

      def primary_terms
        ::Article::ARTICLE_PRIMARY_TERMS | super - %i[degree_level degree_name degree_field contributor_advisor]
      end

      def secondary_terms
        current_ability.current_user.admin? ? super - removed_secondary_terms + :web_of_science_uid : super - removed_secondary_terms
      end

      def removed_secondary_terms
        date_terms - %i[conference_location conference_name conference_section]
      end
    end
  end
end
