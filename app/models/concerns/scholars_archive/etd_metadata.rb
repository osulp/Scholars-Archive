module ScholarsArchive
  module EtdMetadata
    extend ActiveSupport::Concern

    # Usage notes and expectations can be found in the Metadata Application Profile:
    #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

    included do
      property :contributor_advisor, predicate: ::RDF::Vocab::MARCRelators.ths do |index|
        index.as :stored_searchable, :facetable
      end

      property :contributor_committeemember, predicate: ::RDF::Vocab::MARCRelators.dgs do |index|
        index.as :stored_searchable, :facetable
      end

      property :degree_discipline, predicate: ::RDF::URI.new("http://http://dbpedia.org/ontology/academicDiscipline") do |index|
        index.as :stored_searchable
      end

      property :degree_field, predicate: ::RDF::URI.new("http://vivoweb.org/ontology/core#majorField"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :degree_grantors, predicate: ::RDF::Vocab::MARCRelators.dgg, multiple: false do |index|
        index.as :stored_searchable
      end

      property :degree_level, predicate: ::RDF::URI.new("http://purl.org/NET/UNTL/vocabularies/degree-information/#level"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :degree_name, predicate: ::RDF::URI.new("http://purl.org/ontology/bibo/ThesisDegree"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :graduation_year, predicate: ::RDF::URI.new("http://www.rdaregistry.info/Elements/w/#P10215"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end
    end
  end
end
