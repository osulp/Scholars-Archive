# frozen_string_literal: true

module ScholarsArchive
  # etd metadata
  module EtdMetadata
    extend ActiveSupport::Concern

    # Usage notes and expectations can be found in the Metadata Application Profile:
    #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

    included do
      initial_properties = properties.keys
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

      define_singleton_method :etd_properties do
        (properties - initial_properties)
      end

      ETD_PRIMARTY_TERMS = %i[
        nested_ordered_title
        alt_title
        nested_ordered_creator
        nested_ordered_contributor
        nested_ordered_abstract
        license
        resource_type
        doi dates_section
        degree_level
        degree_name
        degree_field
        degree_grantors
        graduation_year
        contributor_advisor
        contributor_committeemember
        bibliographic_citation
        academic_affiliation
        other_affiliation
        in_series
        subject
        tableofcontents
        rights_statement
      ]
    end
  end
end
