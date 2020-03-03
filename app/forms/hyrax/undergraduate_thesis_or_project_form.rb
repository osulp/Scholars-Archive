# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work UndergraduateThesisOrProject`
module Hyrax
  # form object for undergraduate thesis or project
  class UndergraduateThesisOrProjectForm < DefaultForm
    self.model_class = ::UndergraduateThesisOrProject

    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior

    self.required_fields -= [:other_affiliation]
  end
end
