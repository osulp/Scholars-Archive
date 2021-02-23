# frozen_string_literal: true

module ScholarsArchive
  # etd metadata
  module EtdMetadata
    extend ActiveSupport::Concern

    # Usage notes and expectations can be found in the Metadata Application Profile:
    #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

    included do
      property :contributor_committeemember, predicate: ::RDF::Vocab::MARCRelators.dgs do |index|
        index.as :stored_searchable, :facetable
      end

      property :degree_discipline, predicate: ::RDF::URI.new('http://http://dbpedia.org/ontology/academicDiscipline') do |index|
        index.as :stored_searchable
      end

      property :degree_grantors, predicate: ::RDF::Vocab::MARCRelators.dgg, multiple: false do |index|
        index.as :stored_searchable
      end

      # accessor value used by AddOtherFieldOptionActor to persist "Other" values provided by the user
      attr_accessor :degree_grantors_other

      property :graduation_year, predicate: ::RDF::URI.new('http://www.rdaregistry.info/Elements/w/#P10215'), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end
    end
  end
end
