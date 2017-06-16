# Generated via
#  `rails generate hyrax:work ConferenceProceedingsOrJournal`
module Hyrax
  class ConferenceProceedingsOrJournalForm < Hyrax::ArticleForm
    include ScholarsArchive::NestedGeoBehavior
    self.model_class = ::ConferenceProceedingsOrJournal
  end
end
