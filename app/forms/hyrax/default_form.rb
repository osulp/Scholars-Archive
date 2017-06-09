# Generated via
#  `rails generate hyrax:work Default`
module Hyrax
  class DefaultForm < Hyrax::DefaultWorkForm
    self.model_class = ::Default
    delegate :nested_geo_attributes=, :to => :model
    def initialize_fields
      model.nested_geo.build
      super
    end

    def self.build_permitted_params
      super + self.date_terms + [
        {
          :nested_geo_attributes => [:id, :_destroy, :label, :point, :bbox]
        }
      ]
    end
  end
end
