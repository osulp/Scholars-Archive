# Generated via
#  `rails generate hyrax:work UndergraduateThesisOrProject`
class UndergraduateThesisOrProject < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::EtdMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::HasEtdTriplePoweredProperties
  include ScholarsArchive::ExcludedEtdLicenses

  self.indexer = EtdIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.validates_with ScholarsArchive::Validators::GraduationYearValidator
  self.validates_with ScholarsArchive::Validators::OtherOptionDegreeValidator
  self.validates_with ScholarsArchive::Validators::OtherAffiliationValidator
  self.validates_with ScholarsArchive::Validators::NestedRelatedItemsValidator

  private
  def set_defaults
    self.peerreviewed ||= 'FALSE'
  end
end
