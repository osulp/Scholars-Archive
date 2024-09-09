# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work ConferenceProceedingsOrJournal`
module Hyrax
  # form object for conference proceedings or journals
  class ConferenceProceedingsOrJournalForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::ConferenceProceedingsOrJournalFormBehavior

    self.model_class = ::ConferenceProceedingsOrJournal

    self.terms = ::ScholarsArchive::ConferenceTerms.base_terms
  end
end
