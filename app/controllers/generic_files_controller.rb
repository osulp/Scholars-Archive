# app/controllers/generic_files_controller.rb
class GenericFilesController < ApplicationController
  include Sufia::Controller
  include Sufia::FilesControllerBehavior

  self.presenter_class = FilePresenter
  self.edit_form_class = FileEditForm

  def edit
    @generic_file["publisher"] = [t('sufia.default_publisher')] if @generic_file["publisher"].empty?
    @generic_file["language"] = [RDF::URI(t('sufia.default_language_uri'))] if @generic_file["language"].empty?
    super
  end

  def update_metadata
    file_attributes = edit_form_class.model_attributes(params[:generic_file])
    updated_attributes = AttributeURIConverter.new(file_attributes).convert_attributes
    actor.update_metadata(updated_attributes, params[:visibility])
  end

end
