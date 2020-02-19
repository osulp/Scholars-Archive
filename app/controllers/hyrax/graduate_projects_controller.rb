# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GraduateProject`

module Hyrax
  # grad project controller
  class GraduateProjectsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = GraduateProject

    # Use this line if you want to use a custom presenter
    self.show_presenter = GraduateProjectPresenter

    before_action :ensure_admin!, only: :destroy

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end
  end
end
