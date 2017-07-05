# Generated via
#  `rails generate hyrax:work AdministrativeReportOrPublication`
module Hyrax
  class AdministrativeReportOrPublicationForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DefaultWorkFormBehavior

    self.model_class = ::AdministrativeReportOrPublication
  end
end
