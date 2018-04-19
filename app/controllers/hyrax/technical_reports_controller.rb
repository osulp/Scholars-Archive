# Generated via
#  `rails generate hyrax:work TechnicalReport`

module Hyrax
  class TechnicalReportsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = TechnicalReport

    # Use this line if you want to use a custom presenter
    self.show_presenter = TechnicalReportPresenter
    def new
      curation_concern.peerreviewed = "FALSE" if curation_concern.respond_to?(:peerreviewed)
      super
    end
  end
end
