# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work HonorsCollegeThesis`
class HonorsCollegeThesis < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::EtdMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ::ScholarsArchive::FinalizeNestedMetadata
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::HasEtdTriplePoweredProperties
  include ScholarsArchive::ExcludedEtdLicenses
  include ScholarsArchive::HasNestedOrderedProperties

  self.indexer = EtdIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates_with ScholarsArchive::Validators::GraduationYearValidator
  validates_with ScholarsArchive::Validators::OtherOptionDegreeValidator
  validates_with ScholarsArchive::Validators::OtherAffiliationValidator
  validates_with ScholarsArchive::Validators::NestedRelatedItemsValidator

  private

  def set_defaults
    self.resource_type = ['Honors College Thesis'] if resource_type.empty?
    self.other_affiliation = ['http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege'] if other_affiliation.empty?
    self.degree_level ||= "Bachelor's"
    self.peerreviewed ||= 'false'
  end
end
