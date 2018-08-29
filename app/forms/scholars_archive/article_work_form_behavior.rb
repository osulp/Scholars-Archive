module ScholarsArchive
  module ArticleWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += [:resource_type, :editor, :has_volume, :has_number, :conference_location, :conference_name, :conference_section, :has_journal, :is_referenced_by, :web_of_science_uid]

      def primary_terms
        [:nested_ordered_title, :alt_title, :nested_ordered_creator, :contributor, :abstract, :license, :resource_type, :doi, :dates_section, :bibliographic_citation, :is_referenced_by, :has_journal, :has_volume, :has_number, :conference_name, :conference_section, :conference_location, :editor, :academic_affiliation, :other_affiliation, :in_series, :subject, :tableofcontents, :rights_statement] | super - [:degree_level, :degree_name, :degree_field]
      end

      def secondary_terms
        t = super - self.date_terms - [:conference_location, :conference_name, :conference_section]
        t << :web_of_science_uid if current_ability.current_user.admin?
        t
      end
    end
  end
end
