# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
class GraduateThesisOrDissertation < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::EtdMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::HasTriplePoweredProperties
  include ScholarsArchive::ExcludedEtdLicenses

  self.indexer = EtdIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Graduate Thesis Or Dissertation'
end
