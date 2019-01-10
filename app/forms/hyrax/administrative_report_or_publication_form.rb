# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work AdministrativeReportOrPublication`
module Hyrax
  # form object for administrative report or publication
  class AdministrativeReportOrPublicationForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm

    self.model_class = ::AdministrativeReportOrPublication
  end
end
