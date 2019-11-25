# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work EescPublication`
class EescPublication < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::HasTriplePoweredProperties
  include ScholarsArchive::ExcludedDefaultLicenses
  include ScholarsArchive::HasNestedOrderedProperties

  self.indexer = DefaultWorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates_with ScholarsArchive::Validators::NestedRelatedItemsValidator
  validates_with ScholarsArchive::Validators::OtherAffiliationValidator

  private

  def set_defaults
  end
end
