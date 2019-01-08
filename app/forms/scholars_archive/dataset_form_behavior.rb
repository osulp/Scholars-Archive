# frozen_string_literal: true

module ScholarsArchive
  module DatasetFormBehavior
    extend ActiveSupport::Concern
    included do
      include ScholarsArchive::DateTermsBehavior
      include ScholarsArchive::NestedBehavior

      # accessor attributes only used to group dates and geo fields and allow proper ordering in this form
      attr_accessor :dates_section
      attr_accessor :geo_section

      attr_accessor :other_affiliation_other

      self.terms += %i[nested_related_items date_uploaded date_modified doi other_affiliation academic_affiliation alt_title nested_ordered_abstract license resource_type date_available date_copyright date_issued date_collected date_valid date_reviewed date_accepted replaces nested_geo hydrologic_unit_code funding_body funding_statement in_series tableofcontents bibliographic_citation peerreviewed nested_ordered_additional_information digitization_spec file_extent file_format dspace_community dspace_collection isbn issn embargo_reason]

      self.required_fields += %i[resource_type nested_ordered_creator nested_ordered_title]
      self.required_fields -= %i[keyword creator title]

      def primary_terms
        t = %i[nested_ordered_title alt_title nested_ordered_creator academic_affiliation other_affiliation nested_ordered_contributor nested_ordered_abstract license resource_type doi dates_section bibliographic_citation in_series subject rights_statement nested_related_items hydrologic_unit_code geo_section funding_statement publisher peerreviewed language digitization_spec replaces nested_ordered_additional_information] | super
        t << [:description] if current_ability.current_user.admin?
        t.flatten
      end

      def secondary_terms
        []
      end

      def self.date_terms
        %i[
          date_created
          date_available
          date_copyright
          date_issued
          date_collected
          date_valid
          date_reviewed
          date_accepted
        ]
      end

      def date_terms
        self.class.date_terms
      end

      def self.build_permitted_params
        super + date_terms + [:embargo_reason] + [
          {
            nested_geo_attributes: %i[id _destroy point_lat point_lon bbox_lat_north bbox_lon_west bbox_lat_south bbox_lon_east label point bbox],
            nested_ordered_creator_attributes: %i[id _destroy index creator],
            nested_ordered_title_attributes: %i[id _destroy index title],
            nested_ordered_contributor_attributes: %i[id _destroy index contributor],
            nested_ordered_abstract_attributes: %i[id _destroy index abstract],
            nested_ordered_additional_information_attributes: %i[id _destroy index additional_information],
            nested_related_items_attributes: %i[id _destroy label related_url index]
          }
        ] + [
          {
            other_affiliation_other: []
          }
        ]
      end
    end
  end
end
