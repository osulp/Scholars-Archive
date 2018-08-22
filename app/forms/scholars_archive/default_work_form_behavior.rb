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
      attr_accessor :degree_level_other
      attr_accessor :degree_field_other
      attr_accessor :degree_name_other

      self.terms += [:nested_ordered_title, :nested_related_items, :nested_ordered_creator, :date_uploaded, :date_modified, :doi, :other_affiliation, :academic_affiliation, :alt_title, :abstract, :license, :resource_type, :date_available, :date_copyright, :date_issued, :date_collected, :date_valid, :date_reviewed, :date_accepted, :degree_level, :degree_name, :degree_field, :replaces, :nested_geo, :hydrologic_unit_code, :funding_body, :funding_statement, :in_series, :tableofcontents, :bibliographic_citation, :peerreviewed, :additional_information, :digitization_spec, :file_extent, :file_format, :dspace_community, :dspace_collection, :isbn, :issn, :embargo_reason, :conference_name, :conference_section, :conference_location]

      self.terms -= [:creator]
      self.required_fields += [:resource_type, :nested_ordered_creator]
      self.required_fields -= [:keyword, :creator]

      def primary_terms
        [:nested_ordered_title, :alt_title, :nested_ordered_creator, :contributor, :abstract, :license, :resource_type, :doi, :dates_section, :degree_level, :degree_name, :degree_field, :bibliographic_citation, :academic_affiliation, :other_affiliation, :in_series, :subject, :tableofcontents, :rights_statement] | super
      end

      def secondary_terms
        t = [:nested_related_items, :hydrologic_unit_code, :geo_section, :funding_statement, :publisher, :peerreviewed, :conference_name, :conference_section, :conference_location, :language, :file_format, :file_extent, :digitization_spec, :replaces, :additional_information, :isbn, :issn]
        t << [:keyword, :source, :funding_body, :dspace_community, :dspace_collection, :description, :identifier] if current_ability.current_user.admin?
        t.flatten
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
        super + self.date_terms + [
          :degree_level,
          :degree_name,
          :degree_field,
          :embargo_reason,
          :degree_level_other,
          :degree_grantors_other,
          :member_of_collection_ids,
          {
            :nested_geo_attributes => [:id, :_destroy, :point_lat, :point_lon, :bbox_lat_north, :bbox_lon_west, :bbox_lat_south, :bbox_lon_east, :label, :point, :bbox],
            :nested_ordered_creator_attributes => [:id, :_destroy, :index, :creator],
            :nested_ordered_title_attributes => [:id, :_destroy, :index, :title],
            :nested_related_items_attributes => [:id, :_destroy, :label, :related_url],
            :other_affiliation_other => [],
            :degree_field_other => [],
            :degree_name_other => []
          }
        ]
      end

    end
  end
end
