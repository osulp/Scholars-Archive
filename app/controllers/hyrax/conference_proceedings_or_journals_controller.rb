# Generated via
#  `rails generate hyrax:work ConferenceProceedingsOrJournal`

module Hyrax
  class ConferenceProceedingsOrJournalsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ConferenceProceedingsOrJournal

    # Use this line if you want to use a custom presenter
    self.show_presenter = ConferenceProceedingsOrJournalPresenter
    def new
      curation_concern.peerreviewed = "FALSE" if curation_concern.respond_to?(:peerreviewed)
      super
    end
  end
end
