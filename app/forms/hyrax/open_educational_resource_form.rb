# Generated via
#  `rails generate hyrax:work OpenEducationalResource`
module Hyrax
  class OpenEducationalResourceForm < Hyrax::OerForm
    include ScholarsArchive::NestedGeoBehavior
    self.model_class = ::OpenEducationalResource
  end
end
