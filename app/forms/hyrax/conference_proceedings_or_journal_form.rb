# Generated via
#  `rails generate hyrax:work ConferenceProceedingsOrJournal`
module Hyrax
  class ConferenceProceedingsOrJournalForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DefaultWorkFormBehavior
    include ScholarsArchive::ArticleWorkFormBehavior
    self.model_class = ::ConferenceProceedingsOrJournal
  end
end
