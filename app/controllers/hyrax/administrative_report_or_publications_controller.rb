# frozen_string_literal: true

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
  end
end
