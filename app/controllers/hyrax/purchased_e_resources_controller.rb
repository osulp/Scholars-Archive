# Generated via
#  `rails generate hyrax:work PurchasedEResource`

module Hyrax
  class PurchasedEResourcesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::PurchasedEResource
    self.show_presenter = PurchasedEResourcePresenter
  end
end
