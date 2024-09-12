# frozen_string_literal: true

module ScholarsArchive
  # form behavior for etd
  module PurchasedEResourceFormBehavior
    extend ActiveSupport::Concern
    included do
      include ScholarsArchive::DefaultWorkFormBehavior
      attr_accessor :degree_grantors_other

      self.required_fields = %i[nested_ordered_title nested_ordered_creator resource_type rights_statement]
      self.terms += ::ScholarsArchive::PurchasedEResourceTerms.base_terms

      def primary_terms
        ::ScholarsArchive::PurchasedEResourceTerms.primary_terms | super
      end

      def secondary_terms
        t = ::ScholarsArchive::PurchasedEResourceTerms.secondary_terms
        t << ::ScholarsArchive::PurchasedEResourceTerms.admin_terms if current_ability.current_user.admin?
        t.flatten
      end
    end
  end
end
