# app/controllers/batch_controller.rb
class BatchController < ApplicationController
  include ScholarsArchive::BatchControllerBehavior
  before_filter :update_nested_geo_location_attributes, :only => :update
  self.edit_form_class = BatchEditForm

  def update
    unless params["generic_file"]['nested_geo_bbox_attributes'].nil?
      params["generic_file"]["nested_geo_bbox_attributes"].each do |box, value|
        if [value["label"], value["bbox_lat_north"], value["bbox_lon_west"], value["bbox_lat_south"], value["bbox_lon_east"]].none? { |f| f.blank? }
          bbox = [value["bbox_lat_north"], value["bbox_lon_west"], value["bbox_lat_south"], value["bbox_lon_east"]]
          value["bbox"] = bbox.to_s
        end
      end
    end
    super
  end

  protected

  def edit_form
    generic_file = ::GenericFile.new(default_values)
    edit_form_class.new(generic_file)
  end

  def default_values
    {
      "creator" => [current_user.name],
      "title" => @batch.generic_files.map(&:label),
      "publisher" => [TriplePoweredResource.new(RDF::URI(I18n.t('form_defaults.publisher')))],
      "language" => [TriplePoweredResource.new(RDF::URI(I18n.t('form_defaults.language_uri')))]
    }
  end

  # after a file has been updated, determine if there are geo locations to set
  def update_nested_geo_location_attributes
    if !flash[:error]
      self.params = NestedGeoLocation.set_nested_geo_locations(self.params)
    end
  end

end
