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

  # prevents _default.html.erb field generator from rendering these fields
  # with the intention of manually specifying these fields within other partials
  # such as _date_created.html.erb including this :date field as well.
  def self.hidden_fields
    [:date]
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
