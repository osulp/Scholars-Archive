# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work PurchasedEResource`
module Hyrax
  # form object for PER
  class PurchasedEResourceForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::PurchasedEResourceFormBehavior

    self.model_class = ::PurchasedEResource
  end
end
