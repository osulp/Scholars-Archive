# Generated via
#  `rails generate hyrax:work Etd`
class Etd < ActiveFedora::Base

  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::DefaultMetadata
  include ::ScholarsArchive::EtdMetadata
  include ScholarsArchive::TriplePoweredProperties::WorkBehavior
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Etd'
end
