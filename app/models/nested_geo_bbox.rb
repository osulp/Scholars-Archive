class NestedGeoBbox < ActiveTriples::Resource
  validate :check_bbox

  property :label, :predicate => RDF::DC.coverage
  property :bbox, :predicate => RDF::URI("http://opaquenamespace.org/ns/georss/box")
  attr_accessor :bbox_lat_north
  attr_accessor :bbox_lon_west
  attr_accessor :bbox_lat_south
  attr_accessor :bbox_lon_east

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

  protected

  def check_bbox
    # TODO: implement custom format validation to validate bbox inputs
    # require all fields when bbox not empty
    # validates_presence_of :label, :bbox_lat_north, :bbox_lon_west, :bbox_lat_south, :bbox_lon_east
    # binding.pry
    # if [label, bbox_lat_north, bbox_lon_west, bbox_lat_south, bbox_lon_east].any? { |f| !f.empty? }
    #   validate :label, presence => {:message => "Your label can't be blank"}
    #   validate :bbox_lat_north, presence => {:message => "Latitude north can't be blank"}
    #   validate :bbox_lon_west, presence => {:message => "Longitude west can't be blank"}
    #   validate :bbox_lat_south, presence => {:message => "Latitude south can't be blank"}
    #   validate :bbox_lon_east, presence => {:message => "Longitude east can't be blank"}
    #
    # end
  end
end
