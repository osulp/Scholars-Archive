# Generated via
#  `rails generate hyrax:work OpenEducationalResource`
class OpenEducationalResource < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::OerMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::TriplePoweredProperties::WorkBehavior
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::TriplePoweredBehavior

  self.indexer = OerIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Open Educational Resource'
end
