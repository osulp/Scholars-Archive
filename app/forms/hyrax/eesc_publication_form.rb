# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work EescPublication`
module Hyrax
  # form object for eecs publication
  class EescPublicationForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm

    self.model_class = ::EescPublication

    def self.primary_terms
      super - %i[degree_level degree_name degree_field contributor_advisor]
    end
  end
end
