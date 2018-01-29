module ScholarsArchive
  module DefaultWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      include ScholarsArchive::DateTermsBehavior
      include ScholarsArchive::NestedBehavior

      # accessor attributes only used to group dates and geo fields and allow proper ordering in this form
      attr_accessor :dates_section
      attr_accessor :geo_section

      attr_accessor :other_affiliation_other
      attr_accessor :degree_field_other

      self.terms += [:nested_related_items, :date_uploaded, :date_modified, :doi, :other_affiliation, :academic_affiliation, :alt_title, :abstract, :license, :resource_type, :date_available, :date_copyright, :date_issued, :date_collected, :date_valid, :date_reviewed, :date_accepted, :replaces, :nested_geo, :hydrologic_unit_code, :funding_body, :funding_statement, :in_series, :tableofcontents, :bibliographic_citation, :peerreviewed, :additional_information, :digitization_spec, :file_extent, :file_format, :dspace_community, :dspace_collection, :isbn, :issn, :embargo_reason, :conference_location, :conference_name, :conference_section]

      self.required_fields += [:resource_type]
      self.required_fields -= [:keyword]

      def primary_terms
        [:title, :alt_title, :creator, :contributor, :abstract, :license, :resource_type, :doi, :identifier, :dates_section, :bibliographic_citation, :academic_affiliation, :other_affiliation, :in_series, :subject, :tableofcontents, :rights_statement] | super
      end

      def secondary_terms
        [:nested_related_items, :hydrologic_unit_code, :geo_section, :funding_statement, :publisher, :peerreviewed, :conference_location, :conference_name, :conference_section, :language, :file_format, :file_extent, :digitization_spec, :replaces, :additional_information, :isbn, :issn]
      end

      def self.date_terms
        [
          :date_created,
          :date_available,
          :date_copyright,
          :date_issued,
          :date_collected,
          :date_valid,
          :date_reviewed,
          :date_accepted,
        ]
      end

      def date_terms
        self.class.date_terms
      end

      def self.build_permitted_params
        super + self.date_terms + [:embargo_reason] + [
          {
            :nested_geo_attributes => [:id, :_destroy, :point_lat, :point_lon, :bbox_lat_north, :bbox_lon_west, :bbox_lat_south, :bbox_lon_east, :label, :point, :bbox],
            :nested_related_items_attributes => [:id, :_destroy, :label, :related_url]
          }
        ] + [
            {
                :other_affiliation_other => [],
                :degree_field_other => []
            }
        ]
      end
    end
  end
end
