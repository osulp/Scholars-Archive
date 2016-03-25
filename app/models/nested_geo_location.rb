class NestedGeoLocation < ActiveTriples::Resource
  property :name, :predicate => RDF::URI("http://www.geonames.org/ontology#name")
  property :geonames_url, :predicate => RDF::URI("http://schema.org/URL#targetUrl")

  def initialize(uri, parent=nil)
    if uri.try(:node?)
      uri = RDF::URI("#geo_location#{uri.to_s.gsub('_:','')}")
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

  # after a file has been updated, determine if there are geo locations to set
  def self.set_nested_geo_locations(params)
    if params[:generic_file].nil?
      params
    else
      unless params[:generic_file][:nested_geo_location_attributes].nil?
        geo_locations = params[:generic_file][:nested_geo_location_attributes] || {}
        geo_locations.select{|k,v| v[:geonames_url].blank? == false && v[:id].nil? }.each_pair do |key, location|
          # Use rubular.com to check regex
          # http://sws.geonames.org/9166575/
          # http://www.geonames.org/9166575/the-valley-library.html
          # 9166575
          #
          # Match the first set of digits to extract the ID from the url string
          geonames_id = location[:geonames_url].to_s[/^\D*\/*(\d+)/,1]
          unless geonames_id.nil?
            url = "http://sws.geonames.org/#{geonames_id}/"
            params[:generic_file][:nested_geo_location_attributes][key][:geonames_url] = url

            t = TriplePoweredResource.new(RDF::URI(url))
            name = t.attributes['http://www.geonames.org/ontology#name'].first
            params[:generic_file][:nested_geo_location_attributes][key][:name] = name
          end
          raise "Unable to find a valid Geonames ID" if geonames_id.nil?
        end
        params
      end
    end
  end
end
