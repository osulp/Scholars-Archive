# Generated via
#  `rails generate hyrax:work AdministrativeReportOrPublication`

module Hyrax
  class AdministrativeReportOrPublicationsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = AdministrativeReportOrPublication

    # Use this line if you want to use a custom presenter
    self.show_presenter = AdministrativeReportOrPublicationPresenter

    def new
      curation_concern.peerreviewed = "FALSE" if curation_concern.respond_to?(:peerreviewed)
      super
    end
  end
end
