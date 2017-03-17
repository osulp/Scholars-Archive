# Generated via
#  `rails generate hyrax:work DefaultWork`

module Hyrax
  class DefaultWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = DefaultWork
  end
end
