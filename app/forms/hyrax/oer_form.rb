# Generated via
#  `rails generate hyrax:work Oer`
module Hyrax
  class OerForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DefaultWorkFormBehavior
    include ScholarsArchive::OerWorkFormBehavior
    self.model_class = ::Oer
  end
end
