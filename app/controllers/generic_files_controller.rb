# app/controllers/generic_files_controller.rb
class GenericFilesController < ApplicationController
  include Sufia::Controller
  include ScholarsArchive::FilesControllerBehavior

  self.presenter_class = FilePresenter
  self.edit_form_class = FileEditForm

  def update_metadata
    file_attributes = edit_form_class.model_attributes(params[:generic_file])
    updated_attributes = AttributeURIConverter.new(file_attributes).convert_attributes
    actor.update_metadata(updated_attributes, params[:visibility])
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


end
