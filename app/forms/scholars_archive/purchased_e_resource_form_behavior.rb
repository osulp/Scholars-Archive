# frozen_string_literal: true

module ScholarsArchive
    # form behavior for etd
    module PurchasedEResourceFormBehavior
      extend ActiveSupport::Concern
      included do
        include ScholarsArchive::DefaultWorkFormBehavior
        attr_accessor :degree_grantors_other

        self.required_fields = [:nested_ordered_title]
  
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