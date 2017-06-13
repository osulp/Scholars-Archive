# Generated via
#  `rails generate hyrax:work ConferenceProceedingsOrJournal`
class ConferenceProceedingsOrJournal < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::ArticleMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::TriplePoweredProperties::WorkBehavior
  include ScholarsArchive::HasSolrLabels

  self.indexer = ArticleIndexer


  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Conference Proceedings Or Journal'
end
