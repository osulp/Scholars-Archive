module ActiveArchive
  class Geological < ActiveArchive::OrderedNestable
    property :label, predicate: ::RDF::Vocab::DC.title
    property :point, predicate: ::RDF::URI("https://purl.org/geojson/vocab#coordinates")
    property :bbox, predicate: ::RDF::URI("https://purl.org/geojson/vocab#bbox")

    attr_accessor :type

    attr_accessor :point_lat
    attr_accessor :point_lon

    attr_accessor :bbox_lat_north
    attr_accessor :bbox_lon_west
    attr_accessor :bbox_lat_south
    attr_accessor :bbox_lon_east

    def initialize(uri=RDF::Node.new, parent=nil)
      if uri.try(:node?)
        uri = RDF::URI("#nested_geo#{uri.to_s.gsub('_:', '')}")
      elsif uri.start_with?("#")
        uri = RDF::URI(uri)
      end
      super
    end
  end
end
