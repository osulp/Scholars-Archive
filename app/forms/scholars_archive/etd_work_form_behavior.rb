# frozen_string_literal: true

module ScholarsArchive
  # form behavior for etd
  module EtdWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      include ScholarsArchive::DefaultWorkFormBehavior
      attr_accessor :degree_grantors_other

      self.terms += %i[degree_grantors contributor_committeemember graduation_year degree_discipline]
      self.required_fields += %i[degree_level degree_name degree_field degree_grantors graduation_year]

      def primary_terms
        ::ScholarsArchive::EtdTerms.primary_terms | super
      end

      def secondary_terms
        super - date_terms
      end
    end
  end
end
