module ScholarsArchive
  ##
  # Transforms and parses a bounding box for various formats
  class BoundingBox
    ##
    # @param [String, Integer, Float] west lon - min lon - MINX
    # @param [String, Integer, Float] south lat - min lat - MINY
    # @param [String, Integer, Float] east lon - max lon - MAXX
    # @param [String, Integer, Float] north lat - max lat - MAXY
    def initialize(west, south, east, north)
      @west = west
      @south = south
      @east = east
      @north = north
      # TODO: check for valid Geometry and raise if not
      # Latitude is a decimal number between -90.0 and 90.0.
      # Longitude is a decimal number between -180.0 and 180.0.
    end

    ##
    # Returns a bounding box in geojson format
    # @return [String]
    def to_geojson
      # bounding box [(MINX, MINY), (MAXX, MINY), (MAXX, MAXY), (MINX, MAXY), (MINX, MINY)].
      # :type => "Polygon", :coordinates => [[[west, south],[east, south],[east, north],[west, south]]]
      factory = ::RGeo::Cartesian.preferred_factory()
      bbox = ::RGeo::Cartesian::BoundingBox.new(factory)

      bbox_.add(factory.point(west, north))
      bbox_.add(factory.point(south, east))

      h = { :type => "Feature", :bbox => [[west, south, east, north]], :geometry => RGeo::GeoJSON.encode(bbox.to_geometry) }
      h.to_json
    end

    private

    attr_reader :west, :south, :east, :north
  end
end
