# Generated via
#  `rails generate hyrax:work TechnicalReport`
class TechnicalReport < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::HasTriplePoweredProperties
  include ScholarsArchive::ExcludedDefaultLicenses

  self.indexer = DefaultWorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.validates_with ScholarsArchive::Validators::OtherAffiliationValidator
  self.validates_with ScholarsArchive::Validators::NestedRelatedItemsValidator

  self.human_readable_type = 'Technical Report'

  private
  def set_defaults
    self.peerreviewed ||= 'FALSE'
  end
end
