# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Dataset`
class Dataset < ActiveFedora::Base
  before_save :remove_datacite_doi
  after_save :set_datacite_doi

  include ::Hyrax::WorkBehavior
  # Adds behaviors for hyrax-doi plugin.
  include Hyrax::DOI::DOIBehavior
  # Adds behaviors for DataCite DOIs via hyrax-doi plugin.
  include Hyrax::DOI::DataCiteDOIBehavior
  include ::ScholarsArchive::DefaultMetadata
  include ::ScholarsArchive::FinalizeNestedMetadata
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::HasTriplePoweredProperties
  include ScholarsArchive::ExcludedDefaultLicenses
  include ScholarsArchive::HasNestedOrderedProperties

  self.indexer = DefaultWorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates_with ScholarsArchive::Validators::OtherAffiliationValidator
  validates_with ScholarsArchive::Validators::NestedRelatedItemsValidator

  private

  def set_defaults; end

  def remove_datacite_doi
    self.datacite_doi = nil unless persisted?
  end

  def set_datacite_doi
    doi_url = ENV.fetch('DATACITE_MODE', :test).to_sym == :production ? 'https://doi.org' : 'https://handle.stage.datacite.org'
    # Update datacite DOI so that it fits the prefix/ID pattern
    self.datacite_doi = ["#{ENV.fetch('DATACITE_PREFIX', '')}/#{id}"]
    # Set the datacite DOI to the regular DOI metadata if it doesn't already exist
    self.doi ||= "#{doi_url}/#{datacite_doi.first}"
    # Save again if we changed anything
    save if changed?
  end
end
