# app/forms/file_edit_form.rb
class FileEditForm < FilePresenter
  include HydraEditor::Form
  include HydraEditor::Form::Permissions

  self.required_fields = [:title, :creator, :tag, :rights]
end
