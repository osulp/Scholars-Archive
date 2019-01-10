# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work EescPublication`

module Hyrax
  class EescPublicationsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = EescPublication

    # Use this line if you want to use a custom presenter
    self.show_presenter = EescPublicationPresenter
  end
end
