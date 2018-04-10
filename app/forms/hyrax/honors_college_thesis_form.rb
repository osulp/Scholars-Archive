# Generated via
#  `rails generate hyrax:work HonorsCollegeThesis`
module Hyrax
  class HonorsCollegeThesisForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior
    self.model_class = ::HonorsCollegeThesis
    self.terms += [:resource_type]

    self.required_fields += [:contributor_advisor]
  end
end
