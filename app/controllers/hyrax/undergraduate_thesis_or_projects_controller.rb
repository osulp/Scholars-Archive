# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work UndergraduateThesisOrProject`

module Hyrax
  # undergrad thesis controller
  class UndergraduateThesisOrProjectsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
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
