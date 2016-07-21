module Sufia::Works
  module Metadata
    extend ActiveSupport::Concern

    included do
      property :accepted, :predicate => ::RDF::DC.dateAccepted do |index|
        index.as :stored_searchable, :facetable
      end

      property :date, predicate: ::RDF::DC.date do |index|
        index.as :stored_searchable, :facetable
      end

      property :available, predicate: ::RDF::DC.available do |index|
        index.as :stored_searchable, :facetable
      end

      property :copyrighted, predicate: ::RDF::DC.dateCopyrighted do |index|
        index.as :stored_searchable, :facetable
      end

      property :collected, predicate: ::RDF::URI('http://rs.tdwg.org/dwc/terms/measurementDeterminedBy') do |index|
        index.as :stored_searchable, :facetable
      end

      property :issued, predicate: ::RDF::DC.issued do |index|
        index.as :stored_searchable, :facetable
      end

      property :valid, predicate: ::RDF::DC.valid do |index|
        index.as :stored_searchable, :facetable
      end

      property :arkivo_checksum, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#arkivoChecksum'), multiple: false

      property :nested_geo_points, :predicate => ::RDF::URI("http://www.w3.org/2003/12/exif/ns#geo"), :class_name => NestedGeoPoint
      property :nested_geo_bbox, :predicate => ::RDF::URI("https://schema.org/box"), :class_name => NestedGeoBbox
      property :nested_geo_location, :predicate => ::RDF::DC.spatial, :class_name => NestedGeoLocation

      accepts_nested_attributes_for :nested_geo_points, :allow_destroy => true, :reject_if => :all_blank
      accepts_nested_attributes_for :nested_geo_bbox, :allow_destroy => true, :reject_if => :all_blank
      accepts_nested_attributes_for :nested_geo_location, :allow_destroy => true, :reject_if => :all_blank
    end
  end
end
