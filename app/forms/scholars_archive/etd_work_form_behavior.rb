module ScholarsArchive 
  module EtdWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      include ScholarsArchive::DefaultWorkFormBehavior
      attr_accessor :degree_level_other
      attr_accessor :degree_field_other
      self.terms += [:degree_level, :degree_name, :degree_field, :degree_grantors, :contributor_advisor, :contributor_committeemember, :graduation_year, :degree_discipline]
      self.required_fields += [:degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year]

      def primary_terms
        super + [:contributor_advisor, :contributor_committeemember]
      end

      def secondary_terms
        super - self.date_terms + [:degree_discipline]
      end
    end
  end
end
