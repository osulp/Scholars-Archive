# Generated via
class Etd < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  include ::ScholarsArchive::DefaultMetadata
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  
  self.human_readable_type = 'Etd'

  # Add SA@OSU metadata fields not covered by Defaultmetadata
  # TODO: find URI to represent degree properties

  property :degree_name, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable, :facetable
  end
  
  property :date_graduate, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable, :facetable
  end

  property :degree_field, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable, :facetable
  end

  property :degree_level, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable, :facetable
  end

  property :degree_discipline, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
    index.as :stored_searchable, :facetable
  end

  property :degree_grantor, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/relators/dgg") do |index|
    index.as :stored_searchable, :facetable
  end

  property :contributor_advisor, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/relators/ths") do |index|
    index.as :stored_searchable, :facetable
  end 

  property :contributor_committeemember, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/relators/dgs") do |index|
    index.as :stored_searchable, :facetable
  end
end
