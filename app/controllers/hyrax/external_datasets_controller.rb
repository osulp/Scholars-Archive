# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource ExternalDataset`
module Hyrax
  # Generated controller for ExternalDataset
  class ExternalDatasetsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include ScholarsArchive::DatasetsControllerBehavior
    include ScholarsArchive::RedirectIfRestrictedBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ExternalDataset

    # Use this line if you want to use a custom presenter
    self.show_presenter = ExternalDatasetPresenter

    before_action :ensure_admin!, only: :destroy
    after_action :set_doi, only: :create

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end

    def set_doi
      curation_concern.doi = "https://doi.org/10.7267/#{curation_concern.id}" if curation_concern.doi == 'mint-doi'
      curation_concern.doi = '' if curation_concern.doi == 'decline-doi'
      curation_concern.save!
    end
  end
end
