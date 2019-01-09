# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
module Hyrax
  # form object for graduate thesis or dissertation
  class GraduateThesisOrDissertationForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior

    self.model_class = ::GraduateThesisOrDissertation
  end
end
