# Generated via
#  `rails generate hyrax:work DefaultWork`
module Hyrax
  class DefaultWorkForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    self.model_class = ::DefaultWork
    self.terms += [:doi, :alt_title, :abstract, :license, :based_near, :resource_type, :date_available, :date_copyright, :date_issued, :date_collected, :date_valid, :date_accepted, :replaces, :hydrologic_unit_code, :funding_body, :funding_statement, :in_series, :tableofcontents, :bibliographic_citation, :peerreviewed, :additional_information, :digitization_spec, :file_extent, :file_format, :dspace_community, :dspace_collection]
    self.required_fields += [:resource_type]
    self.required_fields -= [:keyword]

    def self.build_permitted_params
      super + self.date_terms
    end

    def primary_terms
      super + [:doi, :based_near, :alt_title, :abstract, :keyword, :license]
    end

    def secondary_terms
      super - self.date_terms - [:license, :resource_type, :description, :keyword]
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
