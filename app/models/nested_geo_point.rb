class NestedGeoPoint < ActiveTriples::Resource
  property :decimalLatitude, :predicate => RDF::URI("http://rs.tdwg.org/dwc/terms/decimalLatitude")
  property :decimalLongitude, :predicate => RDF::URI("http://rs.tdwg.org/dwc/terms/decimalLongitude")

  def initialize(uri=RDF::Node.new, parent=nil)
    if uri.try(:node?)
      uri = RDF::URI("#geo_point#{uri.to_s.gsub('_:','')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

  def final_parent
    parent
  end

  def new_record?
    !type.include?(RDF::URI("http://fedora.info/definitions/v4/repository#Resource"))
  end
end
