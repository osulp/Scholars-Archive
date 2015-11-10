# app/controllers/generic_files_controller.rb
class GenericFilesController < ApplicationController
  include Sufia::Controller
  include ScholarsArchive::FilesControllerBehavior

  self.presenter_class = FilePresenter
  self.edit_form_class = FileEditForm

  def update_metadata
    binding.pry
    file_attributes = edit_form_class.model_attributes(params[:generic_file])
    updated_attributes = AttributeURIConverter.new(file_attributes).convert_attributes
    actor.update_metadata(updated_attributes, params[:visibility])
  end

  def new
    @batch_id = Batch.create.id
  end

end
