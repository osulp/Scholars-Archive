require 'geonames'

module ScholarsArchive
  def geonames
    GeoNames.configure(Rails.application.config.geonames)
    @geonames ||= GeoNames::API.new
  end
  module_function :geonames
end
