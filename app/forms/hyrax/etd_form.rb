# Generated via
#  `rails generate hyrax:work Etd`
module Hyrax
  class EtdForm < Hyrax::DefaultWorkForm
    self.model_class = ::Etd
    self.terms += [:degree_level, :degree_name, :degree_field, :contributor_advisor, :contributor_committeemember, :graduation_year, :degree_discipline]

    def date_terms
      []
    end

    def primary_terms
      super + [:degree_level, :degree_name, :degree_field, :contributor_advisor, :contributor_committeemember, :graduation_year]
    end

    def secondary_terms
      super - self.date_terms + [:degree_discipline]
    end

    def date_terms
      super
    end
  end
end
