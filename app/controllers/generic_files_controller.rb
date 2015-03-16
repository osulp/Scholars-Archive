# app/controllers/generic_files_controller.rb
class GenericFilesController < ApplicationController
  include Sufia::Controller
  include Sufia::FilesControllerBehavior

  self.presenter_class = MyGenericFilePresenter
  self.edit_form_class = MyFileEditForm
end
