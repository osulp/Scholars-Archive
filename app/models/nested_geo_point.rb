class NestedGeoPoint < ActiveTriples::Resource
  property :label, :predicate => RDF::DC.coverage
  property :latitude, :predicate => RDF::URI("http://rs.tdwg.org/dwc/terms/decimalLatitude")
  property :longitude, :predicate => RDF::URI("http://rs.tdwg.org/dwc/terms/decimalLongitude")

  def initialize(uri=RDF::Node.new, parent=nil)
    if uri.try(:node?)
      uri = RDF::URI("#geo_point_#{uri.to_s.gsub('_:','')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

  def final_parent
    parent
  end

  def new_record?
    id.start_with?("#")
  end
end
