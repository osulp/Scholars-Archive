# Generated via
#  `rails generate hyrax:work DefaultWork`
module Hyrax
  class DefaultWorkForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    self.model_class = ::DefaultWork
    self.terms += [:relation, :doi, :other_affiliation, :academic_affiliation, :alt_title, :abstract, :license, :based_near, :resource_type, :date_available, :date_copyright, :date_issued, :date_collected, :date_valid, :date_accepted, :replaces, :nested_geo, :hydrologic_unit_code, :funding_body, :funding_statement, :in_series, :tableofcontents, :bibliographic_citation, :peerreviewed, :additional_information, :digitization_spec, :file_extent, :file_format, :dspace_community, :dspace_collection]

    self.required_fields += [:resource_type]
    self.required_fields -= [:keyword]

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

    def primary_terms
      super + [:other_affiliation, :academic_affiliation, :doi, :based_near, :alt_title, :abstract, :keyword, :license]
    end

    def secondary_terms
      super - self.date_terms - [:license, :resource_type, :description, :keyword, :nested_geo, :dspace_community, :dspace_collection]
    end

    def self.date_terms
      [
        :date_created,
        :date_available,
        :date_copyright,
        :date_issued,
        :date_collected,
        :date_valid,
        :date_accepted,
      ]
    end

    def date_terms
      self.class.date_terms
    end
  end
end
