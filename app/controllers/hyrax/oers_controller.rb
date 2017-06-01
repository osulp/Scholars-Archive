# Generated via
#  `rails generate hyrax:work Oer`

module Hyrax
  class OersController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = Oer
    self.show_presenter = OerPresenter
  end
end
