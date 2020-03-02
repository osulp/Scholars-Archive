# frozen_string_literal: true

module ScholarsArchive
  # oer metadata
  module OerMetadata
    extend ActiveSupport::Concern

    # Usage notes and expectations can be found in the Metadata Application Profile:
    #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

    included do
      initial_properties = properties.keys

      property :interactivity_type, predicate: ::RDF::Vocab::LRMI.interactivityType do |index|
        index.as :stored_searchable
      end

      property :is_based_on_url, predicate: ::RDF::Vocab::LRMI.isBasedOnUrl do |index|
        index.as :stored_searchable
      end

      property :learning_resource_type, predicate: ::RDF::Vocab::LRMI.learningResourceType do |index|
        index.as :stored_searchable
      end

      property :time_required, predicate: ::RDF::Vocab::LRMI.timeRequired do |index|
        index.as :stored_searchable
      end

      property :typical_age_range, predicate: ::RDF::Vocab::LRMI.typicalAgeRange do |index|
        index.as :stored_searchable
      end

      property :duration, predicate: ::RDF::Vocab::MA.duration do |index|
        index.as :stored_searchable
      end

      define_singleton_method :oer_properties do
        (properties - initial_properties)
      end

      OER_TERMS = %i[
        resource_type
        is_based_on_url
        interactivity_type
        learning_resource_type
        typical_age_range
        time_required
        duration
      ].freeze

      OER_PRIMARY_TERMS = %i[
        nested_ordered_title
        alt_title
        nested_ordered_creator
        nested_ordered_contributor
        nested_ordered_abstract
        license
        resource_type
        doi
        dates_section
        time_required
        typical_age_range
        learning_resource_type
        interactivity_type
        is_based_on_url
        bibliographic_citation
        academic_affiliation
        other_affiliation
        in_series subject
        tableofcontents
        rights_statement
      ]
    end
  end
end
