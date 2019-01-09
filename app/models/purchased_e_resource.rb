# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work PurchasedEResource`
class PurchasedEResource < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
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

  self.validates_with ScholarsArchive::Validators::GraduationYearValidator
  self.validates_with ScholarsArchive::Validators::OtherOptionDegreeValidator
  self.validates_with ScholarsArchive::Validators::OtherAffiliationValidator
  self.validates_with ScholarsArchive::Validators::NestedRelatedItemsValidator

  private
  def set_defaults
  end
end
