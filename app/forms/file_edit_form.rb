# app/forms/file_edit_form.rb
class FileEditForm < FilePresenter
  include HydraEditor::Form
  delegate :validators, :to => :model
  include HydraEditor::Form::Permissions
  self.model_class = GenericFile
  self.required_fields = [:title, :rights, :keyword]

  def has_content?
    model.content.has_content?
  end

  def initialize_fields
    model.nested_authors.build
    super
  end

  def self.build_permitted_params
    permitted = super
    permitted << {
      :nested_authors_attributes => [
        :id,
        :_destroy,
        :name,
        :orcid
      ]
    }
    permitted
  end
end
