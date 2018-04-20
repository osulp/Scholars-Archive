# Generated via
#  `rails generate hyrax:work OpenEducationalResource`
class OpenEducationalResource < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::OerMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::HasTriplePoweredProperties
  include ScholarsArchive::ExcludedOerLicenses

  self.indexer = OerIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.validates_with ScholarsArchive::Validators::OtherAffiliationValidator
  self.validates_with ScholarsArchive::Validators::NestedRelatedItemsValidator

  self.human_readable_type = 'Open Educational Resource'

  private
  def set_defaults
  end
end
