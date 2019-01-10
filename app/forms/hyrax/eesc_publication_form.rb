# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work EescPublication`
module Hyrax
  class EescPublicationForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm

    self.model_class = ::EescPublication
  end
end
