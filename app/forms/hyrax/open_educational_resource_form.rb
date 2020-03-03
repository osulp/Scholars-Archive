# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work OpenEducationalResource`
module Hyrax
  # form object for oer
  class OpenEducationalResourceForm < DefaultForm
    self.model_class = ::OpenEducationalResource

    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::OerWorkFormBehavior
  end
end
