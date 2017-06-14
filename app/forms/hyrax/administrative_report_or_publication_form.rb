# Generated via
#  `rails generate hyrax:work AdministrativeReportOrPublication`
module Hyrax
  class AdministrativeReportOrPublicationForm < Hyrax::DefaultWorkForm
    include ScholarsArchive::NestedGeoBehavior

    self.model_class = ::AdministrativeReportOrPublication
  end
end
