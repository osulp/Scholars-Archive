# Generated via
#  `rails generate curation_concerns:work GenericWork`
class GenericWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata

  property :accepted, :predicate => ::RDF::DC.dateAccepted do |index|
    index.as :stored_searchable, :facetable
  end

  property :date, predicate: ::RDF::DC.date do |index|
    index.as :stored_searchable, :facetable
  end
 
  property :available, predicate: ::RDF::DC.available do |index|
    index.as :stored_searchable, :facetable
  end
 
  property :copyrighted, predicate: ::RDF::DC.dateCopyrighted do |index|
    index.as :stored_searchable, :facetable
  end
 
  property :collected, predicate: ::RDF::URI('http://rs.tdwg.org/dwc/terms/measurementDeterminedBy') do |index|
    index.as :stored_searchable, :facetable
  end
 
  property :issued, predicate: ::RDF::DC.issued do |index|
    index.as :stored_searchable, :facetable
  end
 
  property :valid, predicate: ::RDF::DC.valid do |index|
    index.as :stored_searchable, :facetable
  end

  include Sufia::WorkBehavior
  self.human_readable_type = 'Work'
  validates :title, presence: { message: 'Your work must have a title.' }

end
