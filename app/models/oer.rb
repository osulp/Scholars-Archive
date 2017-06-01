# Generated via
#  `rails generate hyrax:work Oer`
class Oer < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::OerMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::TriplePoweredProperties::WorkBehavior
  include SchoalrsArchive::ToSolrBehavior

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Oer'
end
