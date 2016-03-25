require 'geonames'

module ScholarsArchive
  def marmotta
    @marmotta ||= Marmotta::Connection.new(uri: Settings.marmotta.url, context: Rails.env)
  end
  module_function :marmotta

  def geonames
    GeoNames.configure(Rails.application.config.geonames)
    @geonames ||= GeoNames::API.new
  end
  module_function :geonames
end
