# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
module Hyrax
  class GraduateThesisOrDissertationForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior
    self.model_class = ::GraduateThesisOrDissertation
  end
end
