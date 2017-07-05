# Generated via
#  `rails generate hyrax:work Etd`
module Hyrax
  class EtdForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DefaultWorkFormBehavior
    include ScholarsArchive::EtdWorkFormBehavior
    self.model_class = ::Etd
  end
end
