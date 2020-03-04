# frozen_string_literal: true

module ScholarsArchive
  # form behavior for dataset
  module DatasetFormBehavior
    extend ActiveSupport::Concern
    included do
      include ScholarsArchive::DateTermsBehavior
      include ScholarsArchive::NestedBehavior

      # accessor attributes only used to group dates and geo fields and allow proper ordering in this form
      attr_accessor :dates_section
      attr_accessor :geo_section
      attr_accessor :other_affiliation_other

      self.terms += ::Default::DATASET_TERMS
      self.required_fields += %i[resource_type nested_ordered_creator nested_ordered_title]
      self.required_fields -= %i[keyword creator title]

      def primary_terms
        super_terms = super
        current_ability.current_user.admin? ? default_dataset_terms(super_terms) + :description : default_dataset_terms(super_terms)
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

      def default_dataset_terms(super_terms)
        ::Dataset::DATASET_PRIMARY_TERMS | super_terms
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
