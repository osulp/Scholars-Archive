# Generated via
#  `rails generate hyrax:work HonorsCollegeThesis`
module Hyrax
  class HonorsCollegeThesisForm < Hyrax::UndergraduateThesisOrProjectForm
    self.model_class = ::HonorsCollegeThesis
    self.terms += [:resource_type]
  end
end
