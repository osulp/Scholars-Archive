module ScholarsArchive 
  module OerWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += [:resource_type, :is_based_on_url, :interactivity_type, :learning_resource_type, :typical_age_range, :time_required, :duration]
      def primary_terms
        [:title, :alt_title, :creator, :contributor, :abstract, :license, :resource_type, :doi, :identifier, :dates_section, :time_required, :typical_age_range, :learning_resource_type, :interactivity_type, :is_based_on_url, :bibliographic_citation, :academic_affiliation, :other_affiliation, :in_series, :subject, :tableofcontents, :rights_statement] | super
      end

      def secondary_terms
        super - self.date_terms + [:duration]
      end
    end
  end
end
