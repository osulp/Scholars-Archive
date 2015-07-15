# app/forms/file_edit_form.rb
class FileEditForm < FilePresenter
  include HydraEditor::Form
  delegate :validators, :to => :model
  include HydraEditor::Form::Permissions
  self.model_class = GenericFile
  self.required_fields = [:title, :creator, :tag, :rights]

  def has_content?
    model.content.has_content?
  end
end
