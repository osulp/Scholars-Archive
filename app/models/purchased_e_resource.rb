# Generated via
#  `rails generate hyrax:work PurchasedEResource`
class PurchasedEResource < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::EtdMetadata
  include ::ScholarsArchive::ArticleMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::HasEtdTriplePoweredProperties
  include ScholarsArchive::ExcludedEtdLicenses
  include ScholarsArchive::UnrequiredTriplePoweredProperties

  self.indexer = PurchasedEResourceIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.validates_with ScholarsArchive::Validators::GraduationYearValidator

  self.human_readable_type = 'Purchased e-Resource'
end
