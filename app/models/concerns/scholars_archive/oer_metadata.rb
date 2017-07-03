module ScholarsArchive
  module OerMetadata
    extend ActiveSupport::Concern

    included do
      property :interactivity_type, predicate: ::RDF::URI.new("http://purl.org/dcx/lrmi-terms/interactivityType") do |index|
        index.as :stored_searchable
      end

      property :is_based_on_url, predicate: ::RDF::URI.new("http://purl.org/dcx/lrmi-terms/isBasedOnUrl") do |index|
        index.as :stored_searchable
      end

      property :learning_resource_type, predicate: ::RDF::URI.new("http://purl.org/dcx/lrmi-terms/learningResourceType") do |index|
        index.as :stored_searchable
      end

      property :time_required, predicate: ::RDF::URI.new("http://purl.org/dcx/lrmi-terms/timeRequired") do |index|
        index.as :stored_searchable
      end

      property :typical_age_range, predicate: ::RDF::URI.new("http://purl.org/dcx/lrmi-terms/typicalAgeRange") do |index|
        index.as :stored_searchable
      end
    end
  end
end
