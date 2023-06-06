# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work ConferenceProceedingsOrJournal`

module Hyrax
  # conference proceedings controller
  class ConferenceProceedingsOrJournalsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include ScholarsArchive::RedirectIfRestrictedBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ConferenceProceedingsOrJournal

    # Use this line if you want to use a custom presenter
    self.show_presenter = ConferenceProceedingsOrJournalPresenter

    before_action :ensure_admin!, only: :destroy

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end
  end
end
