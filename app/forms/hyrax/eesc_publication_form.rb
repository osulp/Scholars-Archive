# Generated via
#  `rails generate hyrax:work EescPublication`
module Hyrax
  class EescPublicationForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DefaultWorkFormBehavior

    self.model_class = ::EescPublication
  end
end
