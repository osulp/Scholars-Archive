# Generated via
#  `rails generate hyrax:work Etd`
module Hyrax
  class EtdForm < DefaultWorkForm
    include ScholarsArchive::DateTermsBehavior
    self.model_class = ::Etd
    self.terms += [:degree_level, :degree_name, :degree_field, :degree_grantors, :contributor_advisor, :contributor_committeemember, :graduation_year, :degree_discipline]
    self.required_fields += [:degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year]

    def primary_terms
      super + [:contributor_advisor, :contributor_committeemember]
    end

    def secondary_terms
      super - self.date_terms
    end
  end
end
