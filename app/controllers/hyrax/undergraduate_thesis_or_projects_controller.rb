# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work UndergraduateThesisOrProject`

module Hyrax
  # undergrad thesis controller
  class UndergraduateThesisOrProjectsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include ScholarsArchive::RedirectIfRestrictedBehavior
    include Hyrax::BreadcrumbsForWorks
    include ScholarsArchive::BotDetectionBehavior

    # Redirect for Bot Detection
    before_action except: :oai do |controller|
      BotDetectionController.bot_detection_enforce_filter(controller) unless valid_bot?
    end
    # Allow upstream caching of pages
    before_action :allow_page_caching

    self.curation_concern_type = UndergraduateThesisOrProject

    # Use this line if you want to use a custom presenter
    self.show_presenter = UndergraduateThesisOrProjectPresenter

    before_action :ensure_admin!, only: :destroy

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end
  end
end
