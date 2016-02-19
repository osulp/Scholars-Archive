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

  def self.build_permitted_params
    permitted = super
    date_terms.each do |date_term|
      permitted << {
        date_term => []
      }
    end
    permitted << { :keyword => [] }
    permitted << { :creator => [] }
    permitted << { :rights => [] }
    permitted << { :resource_type => [] }
    permitted << { :contributor => [] }
    permitted << { :description => [] }
    permitted << { :date_created => [] }
    permitted << { :identifier => [] }
    permitted << { :based_near => [] }
    permitted << { :related_url => [] }
    permitted << { :language => [] } 
    permitted << { :publisher => [] }
    permitted << { :spatial => [] }
    permitted << { :provenance => [] }
    permitted << { :date => [] }
    permitted << { :doi => [] }
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
