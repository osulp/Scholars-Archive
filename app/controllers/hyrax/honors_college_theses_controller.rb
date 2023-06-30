# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work HonorsCollegeThesis`

module Hyrax
  # honors college thesis controller
  class HonorsCollegeThesesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include ScholarsArchive::RedirectIfRestrictedBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::HonorsCollegeThesis

    # Use this line if you want to use a custom presenter
    self.show_presenter = HonorsCollegeThesisPresenter

    before_action :ensure_admin!, only: :destroy

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end
  end
end
