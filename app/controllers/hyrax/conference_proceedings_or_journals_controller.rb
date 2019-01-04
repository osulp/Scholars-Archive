# frozen_string_literal: true

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
  end
end
