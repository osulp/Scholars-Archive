# app/controllers/batch_controller.rb
class BatchController < ApplicationController
  include ScholarsArchive::BatchControllerBehavior
  self.edit_form_class = BatchEditForm

  def update
    params["generic_file"]["nested_geo_bbox_attributes"].each do |box, value|
      value["bbox"] = value["bbox_lat_north"] + value["bbox_lon_west"] + value["bbox_lat_south"] + value["bbox_lon_east"]
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

end
