# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work HonorsCollegeThesis`

module Hyrax
  class HonorsCollegeThesesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::HonorsCollegeThesis

    # Use this line if you want to use a custom presenter
    self.show_presenter = HonorsCollegeThesisPresenter
  end
end
