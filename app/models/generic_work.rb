# Generated via
#  `rails generate curation_concerns:work GenericWork`
class GenericWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  #include ::ScholarsArchive::DateMetadata
  property :accepted, :predicate => ::RDF::DC.dateAccepted do |index|
    index.as :stored_searchable, :facetable
  end

  include Sufia::WorkBehavior
  self.human_readable_type = 'Work'
  validates :title, presence: { message: 'Your work must have a title.' }

end
