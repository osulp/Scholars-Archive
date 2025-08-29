# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Dataset`

module Hyrax
  # dataset controller
  class DatasetsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include ScholarsArchive::DatasetsControllerBehavior
    include ScholarsArchive::RedirectIfRestrictedBehavior
    include Hyrax::BreadcrumbsForWorks

    # Redirect for Bot Detection
    before_action do |controller|
      Hyrax::BotDetectionController.bot_detection_enforce_filter(controller)
    end

    self.curation_concern_type = Dataset

    # Use this line if you want to use a custom presenter
    self.show_presenter = DatasetPresenter

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
