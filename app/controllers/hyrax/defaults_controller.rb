# Generated via
#  `rails generate hyrax:work Default`

module Hyrax
  class DefaultsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = Default

    # Use this line if you want to use a custom presenter
    self.show_presenter = DefaultPresenter
  end
end
