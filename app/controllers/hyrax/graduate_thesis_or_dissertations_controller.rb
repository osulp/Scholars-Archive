# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`

module Hyrax
  # grad thesis or dissertation controller
  class GraduateThesisOrDissertationsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = GraduateThesisOrDissertation

    # Use this line if you want to use a custom presenter
    self.show_presenter = GraduateThesisOrDissertationPresenter
  end
end
