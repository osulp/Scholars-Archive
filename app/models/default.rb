# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Default`
class Default < ActiveFedora::Base
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

  validates_with ScholarsArchive::Validators::OtherOptionDegreeValidator
  validates_with ScholarsArchive::Validators::OtherAffiliationValidator
  validates_with ScholarsArchive::Validators::NestedRelatedItemsValidator

  def update_index
    super
    FetchGraphWorker.perform_async(id)
  end

  private
  def set_defaults
  end
end
