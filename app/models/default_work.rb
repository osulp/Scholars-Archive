# Generated via
#  `rails generate hyrax:work DefaultWork`
class DefaultWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::DefaultMetadata
  include ::ScholarsArchive::TriplePoweredProperties::WorkBehavior
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Default Work'
end
