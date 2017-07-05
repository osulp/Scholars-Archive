# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  class DatasetForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm

    self.model_class = ::Dataset
  end
end
