# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work PurchasedEResource`
class PurchasedEResource < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  # Adds behaviors for hyrax-doi plugin.
  include Hyrax::DOI::DOIBehavior
  # Adds behaviors for DataCite DOIs via hyrax-doi plugin.
  include Hyrax::DOI::DataCiteDOIBehavior
  include ::ScholarsArchive::EtdMetadata
  include ::ScholarsArchive::ArticleMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::HasPurchasedEResourceTriplePoweredProperties
  include ScholarsArchive::ExcludedEtdLicenses
  include ScholarsArchive::HasNestedOrderedProperties

  self.indexer = PurchasedEResourceIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates_with ScholarsArchive::Validators::GraduationYearValidator
  validates_with ScholarsArchive::Validators::OtherOptionDegreeValidator
  validates_with ScholarsArchive::Validators::OtherAffiliationValidator
  validates_with ScholarsArchive::Validators::NestedRelatedItemsValidator

  private
  def set_defaults
  end
end
