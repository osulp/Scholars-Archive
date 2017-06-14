# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
module Hyrax
  class GraduateThesisOrDissertationForm < Hyrax::EtdForm
    include ScholarsArchive::NestedGeoBehavior
    self.model_class = ::GraduateThesisOrDissertation
  end
end
