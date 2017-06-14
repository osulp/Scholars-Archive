# Generated via
#  `rails generate hyrax:work EescPublication`
module Hyrax
  class EescPublicationForm < Hyrax::DefaultWorkForm
    include ScholarsArchive::NestedGeoBehavior

    self.model_class = ::EescPublication
  end
end
