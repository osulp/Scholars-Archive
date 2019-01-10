# frozen_string_literal: true

module ScholarsArchive
  module EtdWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      include ScholarsArchive::DefaultWorkFormBehavior
      attr_accessor :degree_grantors_other

      self.terms += %i[degree_grantors contributor_advisor contributor_committeemember graduation_year degree_discipline]
      self.required_fields += %i[degree_level degree_name degree_field degree_grantors graduation_year]

      def primary_terms
        %i[nested_ordered_title alt_title nested_ordered_creator nested_ordered_contributor nested_ordered_abstract license resource_type doi dates_section degree_level degree_name degree_field degree_grantors graduation_year contributor_advisor contributor_committeemember bibliographic_citation academic_affiliation other_affiliation in_series subject tableofcontents rights_statement] | super
      end

      def secondary_terms
        super - self.date_terms
      end
    end
  end
end
