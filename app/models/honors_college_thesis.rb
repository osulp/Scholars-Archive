# Generated via
#  `rails generate hyrax:work HonorsCollegeThesis`
class HonorsCollegeThesis < ActiveFedora::Base
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

  self.human_readable_type = 'Honors College Thesis'

  private
  def set_defaults
    self.resource_type ||= ["Honors College Thesis"]
    self.other_affiliation ||= ["http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege"]
    self.degree_level ||= "Bachelor's"
    self.peerreviewed ||= "FALSE"
  end
end
