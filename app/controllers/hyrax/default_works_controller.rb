# Generated via
#  `rails generate hyrax:work DefaultWork`

module Hyrax
  class DefaultWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = DefaultWork
    self.show_presenter = DefaultWorkPresenter

  end
end
