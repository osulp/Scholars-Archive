# frozen_string_literal: true

module ScholarsArchive
  # form behavior for etd
  module EtdWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      include ScholarsArchive::DefaultWorkFormBehavior
      attr_accessor :degree_grantors_other

      self.terms += ScholarsArchive::EtdTerms.base_terms
      self.required_fields += %i[degree_level degree_name degree_field degree_grantors graduation_year]

      def primary_terms
        ::ScholarsArchive::EtdTerms.primary_terms
      end

      def secondary_terms
        t = ::ScholarsArchive::EtdTerms.secondary_terms
        t << ::ScholarsArchive::EtdTerms.admin_terms if current_ability.current_user.admin?
        t.flatten
      end
    end
  end
end
