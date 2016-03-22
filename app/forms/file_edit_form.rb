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

  # @param [Array] fields which shouldn't be automatically rendered by the form
  #   builder.
  # @note The fields specified here would intentionally be rendered in a partial
  #   that might be combined with other fields.. so make sure _default.html.erb
  #   will not render these automatically.
  def self.hidden_fields
    [:date]
  end

  def initialize_fields
    model.nested_authors.build
    model.nested_geo_points.build
    model.nested_geo_bbox.build
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
    permitted << {
      :nested_geo_points_attributes => [
        :id,
        :_destroy,
        :label,
        :latitude,
        :longitude
      ]
    }
    permitted << {
      :nested_geo_bbox_attributes => [
        :id,
        :_destroy,
        :label,
        :bbox,
        :bbox_lat_north,
        :bbox_lon_west,
        :bbox_lat_south,
        :bbox_lon_east
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
      :valid_date,
      :date
    ]
  end

end
