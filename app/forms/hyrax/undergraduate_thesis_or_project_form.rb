# Generated via
#  `rails generate hyrax:work UndergraduateThesisOrProject`
module Hyrax
  class UndergraduateThesisOrProjectForm < Hyrax::EtdForm
    include ScholarsArchive::NestedGeoBehavior
    self.model_class = ::UndergraduateThesisOrProject
  end
end
