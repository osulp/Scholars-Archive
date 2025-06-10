# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource ExternalDataset`
module Hyrax
  # Generated controller for ExternalDataset
  class ExternalDatasetsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::ExternalDataset

    # Use a Valkyrie aware form service to generate Valkyrie::ChangeSet style
    # forms.
    self.work_form_service = Hyrax::FormFactory.new
  end
end
