# frozen_string_literal: true

module ScholarsArchive
  # Form behavior for article
  module ArticleWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += %i[resource_type editor has_volume has_number conference_location conference_name conference_section has_journal is_referenced_by web_of_science_uid]

      def primary_terms
        %i[nested_ordered_title alt_title nested_ordered_creator nested_ordered_contributor nested_ordered_abstract license resource_type doi dates_section bibliographic_citation is_referenced_by has_journal has_volume has_number conference_name conference_section conference_location editor academic_affiliation other_affiliation in_series subject tableofcontents rights_statement] | super - %i[degree_level degree_name degree_field]
      end

      def secondary_terms
        t = super - date_terms - %i[conference_location conference_name conference_section]
        t << :web_of_science_uid if current_ability.current_user.admin?
        t
      end
    end
  end
end
