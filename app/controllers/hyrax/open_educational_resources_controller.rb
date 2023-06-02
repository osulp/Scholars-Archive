# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work OpenEducationalResource`

module Hyrax
  # oer controller
  class OpenEducationalResourcesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include ScholarsArchive::RedirectIfEmbargoBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = OpenEducationalResource

    # Use this line if you want to use a custom presenter
    self.show_presenter = OpenEducationalResourcePresenter

    before_action :ensure_admin!, only: :destroy

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end
  end
end
