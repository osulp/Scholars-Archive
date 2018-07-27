module ScholarsArchive
  module OerWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += [:resource_type, :is_based_on_url, :interactivity_type, :learning_resource_type, :typical_age_range, :time_required, :duration]

      def primary_terms
        if current_ability.current_user && current_ability.current_user.admin?
          super
        else
          [:title, :alt_title, :creator, :contributor, :abstract, :license, :resource_type, :doi, :dates_section, :time_required, :typical_age_range, :learning_resource_type, :interactivity_type, :is_based_on_url, :bibliographic_citation, :academic_affiliation, :other_affiliation, :in_series, :subject, :tableofcontents, :rights_statement] | super - [:degree_level, :degree_name, :degree_field]
        end
      end

      def secondary_terms
        if current_ability.current_user && current_ability.current_user.admin?
          super
        else
          super - self.date_terms + [:duration]
        end 
      end
    end
  end
end
