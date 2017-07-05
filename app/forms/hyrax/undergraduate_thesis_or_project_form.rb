# Generated via
#  `rails generate hyrax:work UndergraduateThesisOrProject`
module Hyrax
  class UndergraduateThesisOrProjectForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DefaultWorkFormBehavior
    include ScholarsArchive::EtdWorkFormBehavior
    self.model_class = ::UndergraduateThesisOrProject
    self.required_fields -= [:degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year]
    
    def primary_terms
      super + [:degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year]
    end
  end
end
