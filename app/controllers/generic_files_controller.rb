# app/controllers/generic_files_controller.rb
class GenericFilesController < ApplicationController
  include Sufia::Controller
  include ScholarsArchive::FilesControllerBehavior

  after_filter :notify_if_shared, :only => :update
  before_filter :update_nested_geo_location_attributes, :only => :update

  self.presenter_class = FilePresenter
  self.edit_form_class = FileEditForm

  def update_metadata
    params["generic_file"]["nested_geo_bbox_attributes"].each do |box, value|
      if [value["label"], value["bbox_lat_north"], value["bbox_lon_west"], value["bbox_lat_south"], value["bbox_lon_east"]].none? { |f| f.blank? }
        bbox = [value["bbox_lat_north"], value["bbox_lon_west"], value["bbox_lat_south"], value["bbox_lon_east"]]
        value["bbox"] = bbox.to_s
      end
    end
    file_attributes = edit_form_class.model_attributes(params[:generic_file])
    updated_attributes = AttributeURIConverter.new(file_attributes).convert_attributes
    actor.update_metadata(updated_attributes, params[:visibility])
  end

  # routed to /files/:id/edit
  def edit
    @generic_file.nested_geo_bbox.each do |box|
      # bbox is stored as a string array of lat/long string arrays like: '["121.1", "121.2", "44.1", "44.2"]', however only one array of lat/long array is stored, so the first will need to be converted to simple array of strings like: ["121.1","121.2","44.1","44.2"]
      box_array = box.bbox.to_a.first.tr('[]" ','').split(',')
      box.bbox_lat_north = box_array[0]
      box.bbox_lon_west = box_array[1]
      box.bbox_lat_south = box_array[2]
      box.bbox_lon_east = box_array[3]
    end
    super
  end

  # routed to /files/:id/daily_stats
  def daily_stats
    header = "This file was generated on #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")} and represents statistics for the item  title: #{load_resource_from_solr.title.first}\nLocation:,#{resource_file_path}\n"
    respond_to do |format|
      format.csv { send_data "#{header}#{stats.daily_stats_csv}", filename: "daily_stats_#{params[:id]}.csv" }
    end
  end

  # routed to /files/:id/monthly_stats
  def monthly_stats
    header = "This file was generated on #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")} and represents statistics for the item  title: #{load_resource_from_solr.title.first}\nLocation:,#{resource_file_path}\n"
    respond_to do |format|
      format.csv { send_data "#{header}#{stats.monthly_stats_csv}", filename: "monthly_stats_#{params[:id]}.csv" }
    end
  end

  def new
    @batch_id = Batch.create.id
  end

  private

  def resource_file_path
    Sufia::Engine.routes.url_helpers.generic_file_url(stats.id, :only_path => false, :host => request.host)
  end

  # after a file has been updated, determine if there are users to notify that
  # they have access shared to them
  def notify_if_shared
    if !flash[:error]
      unless params[:generic_file].nil?
        # updates to description or version will not include the permission
        # attributes, so no notification is relevant
        users = params[:generic_file][:permissions_attributes] || {}
        users.each_pair do |k,u|
          if u[:type] == "user"
            user = User.find_by_username(u[:name])
            if user.has_default_email?
              UserMailer.support_invalid_user(user).deliver_now
            else
              UserMailer.shared_access_to(user, @generic_file, u[:access]).deliver_now
            end
          end
        end
      end
    end
  end

  # after a file has been updated, determine if there are geo locations to set
  def update_nested_geo_location_attributes
    if !flash[:error]
      self.params = NestedGeoLocation.set_nested_geo_locations(self.params)
    end
  end
end
