# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work UndergraduateThesisOrProject`
class UndergraduateThesisOrProject < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  # Adds behaviors for hyrax-doi plugin.
  include Hyrax::DOI::DOIBehavior
  # Adds behaviors for DataCite DOIs via hyrax-doi plugin.
  include Hyrax::DOI::DataCiteDOIBehavior
  include ::ScholarsArchive::EtdMetadata
  include ::ScholarsArchive::DefaultMetadata
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
    self.peerreviewed ||= 'FALSE'
  end
end
