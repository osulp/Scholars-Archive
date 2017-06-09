# Generated via
#  `rails generate hyrax:work GraduateProject`
class GraduateProject < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::EtdMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::TriplePoweredProperties::WorkBehavior
  include ScholarsArchive::HasSolrNestedGeoLabels

  self.indexer = EtdIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Graduate Project'
end
