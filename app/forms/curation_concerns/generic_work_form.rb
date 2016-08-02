# Generated via
#  `rails generate curation_concerns:work GenericWork`
module CurationConcerns
  class GenericWorkForm < Sufia::Forms::WorkForm
    self.model_class = ::GenericWork
    self.terms += [:resource_type, :spatial, :nested_geo_points, :nested_geo_bbox, :nested_geo_location]

    delegate :nested_geo_points_attributes=, :to => :model
    delegate :nested_geo_bbox_attributes=, :to => :model
    delegate :nested_geo_location_attributes=, :to => :model

    def self.date_terms
      [
        :accepted,
        :available,
        :copyrighted,
        :collected,
        :issued,
        :valid,
      ]
    end

    def initialize_fields
      model.nested_geo_points.build
      model.nested_geo_bbox.build
      model.nested_geo_location.build
      super
    end

    # Fields that are in rendered terms are automatically drawn on the page.
    def secondary_terms
      super - [:nested_geo_points, :nested_geo_bbox, :nested_geo_location]
    end

    def self.build_permitted_params
      permitted = super

      date_terms.each do |date_term|
        permitted << {
          date_term => []
        }
      end

      permitted << {
        :nested_geo_points_attributes => [
          :label,
          :latitude,
          :longitude,
          :id,
          :_destroy
        ]
      }
      permitted << {
        :nested_geo_bbox_attributes => [
          :label,
          :bbox,
          :id,
          :_destroy
        ]
      }
      permitted << {
        :nested_geo_location_attributes => [
          :id,
          :_destroy,
          :name,
          :geonames_url
        ]
      }
      permitted
    end

  end
end
