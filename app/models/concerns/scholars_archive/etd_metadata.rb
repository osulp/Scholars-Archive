module ScholarsArchive
  module EtdMetadata
    extend ActiveSupport::Concern

    included do
      #reusable metadata fields for DSpace migration
      property :contributor_advisor, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/relators/ths") do |index|
        index.as :stored_searchable, :facetable
      end

      property :contributor_committeemember, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/relators/dgs") do |index|
        index.as :stored_searchable, :facetable
      end

      property :degree_discipline, predicate: ::RDF::URI.new("http://http://dbpedia.org/ontology/academicDiscipline") do |index|
        index.as :stored_searchable
      end

      property :degree_field, predicate: ::RDF::URI.new("http://vivoweb.org/ontology/core#majorField") do |index|
        index.as :stored_searchable, :facetable
      end

      property :degree_grantors, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/relators/dgg") do |index|
        index.as :stored_searchable
      end

      property :degree_level, predicate: ::RDF::URI.new("http://purl.org/NET/UNTL/vocabularies/degree-information/#level") do |index|
        index.as :stored_searchable, :facetable
      end

      property :degree_name, predicate: ::RDF::URI.new("http://purl.org/ontology/bibo/ThesisDegree") do |index|
        index.as :stored_searchable, :facetable
      end

      property :graduation_year, predicate: ::RDF::URI.new("http://www.rdaregistry.info/Elements/w/#P10215") do |index|
        index.as :stored_searchable, :facetable
      end
    end
  end
end
