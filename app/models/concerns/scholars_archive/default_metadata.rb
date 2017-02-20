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

	  property :date_available, predicate: ::RDF::URI.new("http://purl.org/dc/terms/available") do |index|
	    index.as :stored_searchable
	  end

	  property :date_updated, predicate: ::RDF::URI.new("http://datacite.org/schema/kernel-4/dateType/Updated") do |index|
	    index.as :stored_searchable
	  end

	  property :citation, predicate: ::RDF::URI.new("http://purl.org/dc/terms/bibliographicCitation") do |index|
	    index.as :stored_searchable
	  end

	  property :isbn, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/identifiers/isbn-a") do |index|
	    index.as :stored_searchable
	  end

	  property :identifier_uri, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/identifiers/uri") do |index|
	    index.as :stored_searchable
	  end

	  property :doi, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/identifiers/doi") do |index|
	    index.as :stored_searchable
	  end

	  property :additional_information, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
	    index.as :stored_searchable
	  end

	  property :relation, predicate: ::RDF::URI.new("http://purl.org/dc/terms/relation") do |index|
	    index.as :stored_searchable
	  end

	  property :date_copyright, predicate: ::RDF::URI.new("http://purl.org/dc/terms/dateCopyrighted") do |index|
	    index.as :stored_searchable
	  end
	  
	  property :handle, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/identifiers/hdl") do |index|
	    index.as :stored_searchable
	  end
	  
	  property :dspace_collection, predicate: ::RDF::URI.new("http://purl.org/dc/terms/isPartOf") do |index|
	  end
	  
	  property :dspace_community, predicate: ::RDF::URI.new("http://purl.org/dc/terms/isPartOf") do |index|
	  end
	  
	  property :funding_statement, predicate: ::RDF::URI.new("http://datacite.org/schema/kernel-4/fundingReference") do |index|
	    index.as :stored_searchable
	  end

	  property :funding_body, predicate: ::RDF::URI.new("http://id.loc.gov/authorities/names") do |index|
	    index.as :stored_searchable, :facetable
	  end 
    end
  end
end
