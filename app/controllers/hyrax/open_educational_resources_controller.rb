# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work OpenEducationalResource`

module Hyrax
  class OpenEducationalResourcesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = OpenEducationalResource

    # Use this line if you want to use a custom presenter
    self.show_presenter = OpenEducationalResourcePresenter
  end
end
