# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work PurchasedEResource`

module Hyrax
  # per controller
  class PurchasedEResourcesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::PurchasedEResourceWorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::PurchasedEResource
    self.show_presenter = PurchasedEResourcePresenter
  end
end
