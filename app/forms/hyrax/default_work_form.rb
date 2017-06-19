# Generated via
#  `rails generate hyrax:work DefaultWork`
module Hyrax
  class DefaultWorkForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DateTermsBehavior
    include ScholarsArchive::NestedGeoBehavior

    self.model_class = ::DefaultWork
    self.terms += [:relation, :doi, :other_affiliation, :academic_affiliation, :alt_title, :abstract, :license, :resource_type, :date_available, :date_copyright, :date_issued, :date_collected, :date_valid, :date_accepted, :replaces, :nested_geo, :hydrologic_unit_code, :funding_body, :funding_statement, :in_series, :tableofcontents, :bibliographic_citation, :peerreviewed, :additional_information, :digitization_spec, :file_extent, :file_format, :dspace_community, :dspace_collection]

    self.required_fields += [:resource_type]
    self.required_fields -= [:keyword]

    def primary_terms
      [:title, :alt_title, :creator, :contributor, :abstract, :license, :resource_type, :doi, :identifier, :bibliographic_citation, :academic_affiliation, :other_affiliation, :in_series, :keyword, :subject, :tableofcontents, :rights_statement] | super
    end

    def secondary_terms
      super - self.date_terms + [:related_url, :hydrologic_unit_code, :based_near, :funding_statement, :publisher, :peerreviewed, :language, :file_format, :file_extent, :digitization_spec, :replaces, :relation, :additional_information, :source]
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

    def self.build_permitted_params
      super + self.date_terms + [
          {
            :nested_geo_attributes => [:id, :_destroy, :label, :point, :bbox]
          }
        ]
    end
  end
end
