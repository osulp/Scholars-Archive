# Generated via
#  `rails generate hyrax:work DefaultWork`
class DefaultWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  
  self.human_readable_type = 'Default Work'

  # Add SA@OSU metadata fields not covered by basicmetadata
  # metadata crosswalk: subject -> keyowrd, subject_lcsh -> subject, type -> resource_type 

  property :orcid, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/identifiers/orcid") do |index|
    index.as :stored_searchable
  end

  property :alternative_title, predicate: ::RDF::URI.new("http://purl.org/dc/terms/alternative") do |index|
    index.as :stored_searchable, :facetable
  end

  property :date_issued, predicate: ::RDF::URI.new("http://purl.org/dc/terms/issued") do |index|
    index.as :stored_searchable, :facetable
  end

  property :date_embargo, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable
  end

  property :date_updated, predicate: ::RDF::URI.new("http://purl.org/dc/terms/date") do |index|
    index.as :stored_searchable
  end

  property :peerreview, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable, :facetable
  end

  property :peerreviewnotes, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable
  end

  property :citation, predicate: ::RDF::URI.new("http://purl.org/dc/terms/identifier") do |index|
    index.as :stored_searchable
  end

  property :isbn, predicate: ::RDF::URI.new("http://purl.org/dc/terms/identifier") do |index|
    index.as :stored_searchable
  end

  property :identifier_uri, predicate: ::RDF::URI.new("http://purl.org/dc/terms/identifier") do |index|
    index.as :stored_searchable
  end

  property :doi, predicate: ::RDF::URI.new("http://purl.org/dc/terms/identifier") do |index|
    index.as :stored_searchable
  end

  property :ispartofseries, predicate: ::RDF::URI.new("http://purl.org/dc/terms/relation") do |index|
    index.as :stored_searchable
  end

  property :tableofcontents, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable
  end

  property :digitization, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable
  end

  property :description, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable
  end

  property :sponsorship, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable
  end

  property :relation, predicate: ::RDF::URI.new("http://purl.org/dc/terms/relation") do |index|
    index.as :stored_searchable
  end

  property :funding_statement, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable
  end

  property :funding_body, predicate: ::RDF::URI.new("http://id.loc.gov/authorities/names") do |index|
    index.as :stored_searchable, :facetable
  end
end
