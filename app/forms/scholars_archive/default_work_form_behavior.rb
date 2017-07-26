module ScholarsArchive 
  module DefaultWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      include ScholarsArchive::DateTermsBehavior
      include ScholarsArchive::NestedBehavior

      self.terms += [:nested_related_items, :date_uploaded, :date_modified, :doi, :other_affiliation, :academic_affiliation, :alt_title, :abstract, :license, :resource_type, :date_available, :date_copyright, :date_issued, :date_collected, :date_valid, :date_accepted, :replaces, :nested_geo, :hydrologic_unit_code, :funding_body, :funding_statement, :in_series, :tableofcontents, :bibliographic_citation, :peerreviewed, :additional_information, :digitization_spec, :file_extent, :file_format, :dspace_community, :dspace_collection, :isbn, :issn]

      self.required_fields += [:resource_type]
      self.required_fields -= [:keyword]

      def primary_terms
        [:title, :alt_title, :creator, :contributor, :abstract, :license, :resource_type, :doi, :identifier, :bibliographic_citation, :academic_affiliation, :other_affiliation, :in_series, :keyword, :subject, :tableofcontents, :rights_statement] | super
      end

      def secondary_terms
        [:nested_related_items, :hydrologic_unit_code, :funding_statement, :publisher, :peerreviewed, :language, :file_format, :file_extent, :digitization_spec, :replaces, :additional_information, :source, :isbn, :issn]
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
            :nested_geo_attributes => [:id, :_destroy, :label, :point, :bbox],
            :nested_related_items_attributes => [:id, :_destroy, :label, :related_url]
          }
        ]
      end
    end
  end
end
