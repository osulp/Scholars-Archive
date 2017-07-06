# Generated via
#  `rails generate hyrax:work ConferenceProceedingsOrJournal`
module Hyrax
  class ConferenceProceedingsOrJournalForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::ArticleWorkFormBehavior

    self.model_class = ::ConferenceProceedingsOrJournal
  end
end
