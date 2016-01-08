# app/forms/file_edit_form.rb
class FileEditForm < FilePresenter
  include HydraEditor::Form
  delegate :validators, :content, :to => :model
  delegate :has_content?, :to => :content
  include HydraEditor::Form::Permissions
  self.model_class = GenericFile
  self.required_fields = [:title, :rights]
  self.terms -= [:accepted, :available, :copyrighted, :collected, :creator, :created, :issued, :submitted, :modified, :valid_date, :keyword]

  def has_content?
    model.content.has_content?
  end

  def initialize_fields
    model.nested_authors.build
    super
  end

  def self.model_attributes(form_params)
    clean_params = sanitize_params(form_params)
    terms.each do |key|
      clean_params[key].delete('') if clean_params[key]
    end
    clean_params
  end

  def self.sanitize_params(form_params)
    form_params.permit(*permitted_params)
  end

  def self.permitted_params
    @permitted ||= build_permitted_params
  end

  def self.build_permitted_params
    permitted = super
    date_terms.each do |date_term|
      permitted << {
        date_term => []
      }
    end
    permitted << { :keyword => [] }
    permitted << { :creator => [] }
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
      :collected,
      :issued,
      :valid_date
    ]
  end
end
