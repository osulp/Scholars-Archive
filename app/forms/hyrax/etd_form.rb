# Generated via
#  `rails generate hyrax:work Etd`
module Hyrax
  class EtdForm < Hyrax::DefaultWorkForm
    self.model_class = ::Etd
    self.terms += [:degree_level, :degree_name, :degree_field, :degree_grantors, :contributor_advisor, :contributor_committeemember, :graduation_year, :degree_discipline]
    self.required_fields += [:degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year]

    def date_terms
      []
    end

    def primary_terms
      super + [:contributor_advisor, :contributor_committeemember]
    end

    def secondary_terms
      super - self.date_terms + [:degree_discipline]
    end
  end
end
