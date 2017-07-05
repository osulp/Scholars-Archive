# Generated via
#  `rails generate hyrax:work OpenEducationalResource`
module Hyrax
  class OpenEducationalResourceForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DefaultWorkFormBehavior
    include ScholarsArchive::OerWorkFormBehavior
    self.model_class = ::OpenEducationalResource
  end
end
