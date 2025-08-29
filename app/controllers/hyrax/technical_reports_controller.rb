# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work TechnicalReport`

module Hyrax
  # technical report controller
  class TechnicalReportsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include ScholarsArchive::RedirectIfRestrictedBehavior
    include Hyrax::BreadcrumbsForWorks

    # Redirect for Bot Detection
    before_action do |controller|
      Hyrax::BotDetectionController.bot_detection_enforce_filter(controller)
    end

    self.curation_concern_type = TechnicalReport

    # Use this line if you want to use a custom presenter
    self.show_presenter = TechnicalReportPresenter

    before_action :ensure_admin!, only: :destroy

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end
  end
end
