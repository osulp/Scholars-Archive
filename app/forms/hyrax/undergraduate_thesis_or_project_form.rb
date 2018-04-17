# Generated via
#  `rails generate hyrax:work UndergraduateThesisOrProject`
module Hyrax
  class UndergraduateThesisOrProjectForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior

    self.model_class = ::UndergraduateThesisOrProject
    self.required_fields -= [:degree_grantors]
  end
end
