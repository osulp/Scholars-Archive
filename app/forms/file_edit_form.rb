# app/forms/file_edit_form.rb
class FileEditForm < FilePresenter
  include HydraEditor::Form
  delegate :validators, :content, :to => :model
  delegate :has_content?, :to => :content
  include HydraEditor::Form::Permissions
  self.model_class = GenericFile
  self.required_fields = [:title, :rights, :keyword]
  self.terms -= [:accepted, :available, :copyrighted,:created, :issued,:submitted,:modified, :valid_date]

  def has_content?
    model.content.has_content?
  end

  def initialize_fields
    model.nested_authors.build
    super
  end

  def self.build_permitted_params
    permitted = super
    date_terms.each do |date_term|
      permitted << {
        date_term => []
      }
    end
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

  private

  def self.date_terms
    [
      :accepted,
      :available,
      :copyrighted,
      :issued,
      :valid_date
    ]
  end
end
