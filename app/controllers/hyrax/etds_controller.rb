# Generated via
#  `rails generate hyrax:work Etd`

module Hyrax
  class EtdsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::BreadcrumbsForWorks
    include ScholarsArchive::WorksControllerBehavior
    self.curation_concern_type = Etd
    self.show_presenter = EtdPresenter
  end
end
