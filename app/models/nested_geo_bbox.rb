class NestedGeoBbox < ActiveTriples::Resource
  property :label, :predicate => RDF::DC.coverage
  property :bbox, :predicate => RDF::URI("http://opaquenamespace.org/ns/georss/box")

  def initialize(uri=RDF::Node.new, parent=nil)
    if uri.try(:node?)
      uri = RDF::URI("#geo_bbox#{uri.to_s.gsub('_:','')}")
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
