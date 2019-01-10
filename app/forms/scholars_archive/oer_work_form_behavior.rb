# frozen_string_literal: true

module ScholarsArchive
  module OerWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += %i[resource_type is_based_on_url interactivity_type learning_resource_type typical_age_range time_required duration]

      def primary_terms
        %i[nested_ordered_title alt_title nested_ordered_creator nested_ordered_contributor nested_ordered_abstract license resource_type doi dates_section time_required typical_age_range learning_resource_type interactivity_type is_based_on_url bibliographic_citation academic_affiliation other_affiliation in_series subject tableofcontents rights_statement] | super - %i[degree_level degree_name degree_field]
      end

      def secondary_terms
        super - self.date_terms + [:duration]
      end
    end
  end
end
