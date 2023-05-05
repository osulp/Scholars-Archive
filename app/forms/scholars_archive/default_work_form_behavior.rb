# frozen_string_literal: true

module ScholarsArchive
  # Form behavior for default work
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

      self.terms += ::ScholarsArchive::DefaultTerms.base_terms

      self.terms -= %i[creator title]
      self.required_fields += %i[resource_type nested_ordered_creator nested_ordered_title]
      self.required_fields -= %i[keyword creator title contributor]

      def primary_terms
        ::ScholarsArchive::DefaultTerms.primary_terms | super
      end

      def secondary_terms
        t = ::ScholarsArchive::DefaultTerms.secondary_terms
        t << ::ScholarsArchive::DefaultTerms.admin_terms if current_ability.current_user.admin?
        t.flatten
      end

      def self.date_terms
        %i[date_created] + ::ScholarsArchive::DefaultTerms.date_terms
      end

      def date_terms
        self.class.date_terms
      end

      def self.build_permitted_params
        super + date_terms + [
          :degree_level,
          :degree_name,
          :degree_field,
          :embargo_reason,
          :degree_level_other,
          :degree_grantors_other,
          :member_of_collection_ids,
          :documentation,
          {
            nested_geo_attributes: %i[id _destroy point_lat point_lon bbox_lat_north bbox_lon_west bbox_lat_south bbox_lon_east label point bbox],
            nested_ordered_creator_attributes: %i[id _destroy index creator],
            nested_ordered_title_attributes: %i[id _destroy index title],
            nested_ordered_contributor_attributes: %i[id _destroy index contributor],
            nested_ordered_abstract_attributes: %i[id _destroy index abstract],
            nested_ordered_additional_information_attributes: %i[id _destroy index additional_information],
            nested_related_items_attributes: %i[id _destroy label related_url index],
            other_affiliation_other: [],
            degree_field_other: [],
            degree_name_other: []
          }
        ]
      end
    end
  end
end
