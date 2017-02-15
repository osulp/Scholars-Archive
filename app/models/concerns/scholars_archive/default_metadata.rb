module ScholarsArchive
  module DefaultMetadata
    extend ActiveSupport::Concern

    #reusable metadata fields for DSpace migration 
    included do
	  property :orcid, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/identifiers/orcid") do |index|
	    index.as :stored_searchable
	  end

	  property :date_issued, predicate: ::RDF::URI.new("http://purl.org/dc/terms/issued") do |index|
	    index.as :stored_searchable, :facetable
	  end

	  property :date_embargo, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
	    index.as :stored_searchable
	  end

	  property :date_available, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
	    index.as :stored_searchable
	  end

	  property :date_updated, predicate: ::RDF::URI.new("http://purl.org/dc/terms/date") do |index|
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

	  property :additional_information, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
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
  end
end
