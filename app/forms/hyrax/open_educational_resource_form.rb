# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work OpenEducationalResource`
module Hyrax
  class OpenEducationalResourceForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::OerWorkFormBehavior

    self.model_class = ::OpenEducationalResource
  end
end
