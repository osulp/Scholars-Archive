# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work OpenEducationalResource`
class OpenEducationalResource < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::OerMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ::ScholarsArchive::FinalizeNestedMetadata
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::HasTriplePoweredProperties
  include ScholarsArchive::ExcludedOerLicenses
  include ScholarsArchive::HasNestedOrderedProperties

  self.indexer = OerIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates_with ScholarsArchive::Validators::OtherAffiliationValidator
  validates_with ScholarsArchive::Validators::NestedRelatedItemsValidator

  private

  def set_defaults
    self.accessibility_feature = ['unknown']
  end
end
