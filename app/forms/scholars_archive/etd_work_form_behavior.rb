module ScholarsArchive
  module EtdWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      include ScholarsArchive::DefaultWorkFormBehavior
      attr_accessor :degree_grantors_other

      self.terms += [:degree_grantors, :contributor_advisor, :contributor_committeemember, :graduation_year, :degree_discipline]
      self.required_fields += [:degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year, :academic_affiliation]

      def primary_terms
        [:title, :alt_title, :creator, :contributor, :abstract, :license, :resource_type, :doi, :dates_section, :degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year, :contributor_advisor, :contributor_committeemember, :bibliographic_citation, :academic_affiliation, :other_affiliation, :in_series, :subject, :tableofcontents, :rights_statement] | super
      end

      def secondary_terms
        super - self.date_terms
      end
    end
  end
end
