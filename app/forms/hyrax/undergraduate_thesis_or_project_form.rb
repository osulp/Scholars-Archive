# Generated via
#  `rails generate hyrax:work UndergraduateThesisOrProject`
module Hyrax
  class UndergraduateThesisOrProjectForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior

    self.model_class = ::UndergraduateThesisOrProject
    self.required_fields -= [:degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year]
    
    def primary_terms
      super + [:degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year, :contributor_advisor, :contributor_committeemember]
    end
  end
end
