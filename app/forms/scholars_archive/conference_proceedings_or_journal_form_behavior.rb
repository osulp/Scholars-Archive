# frozen_string_literal: true

module ScholarsArchive
  # form behavior for etd
  module ConferenceProceedingsOrJournalFormBehavior
    extend ActiveSupport::Concern
    included do
      include ScholarsArchive::DefaultWorkFormBehavior
      attr_accessor :degree_grantors_other

      self.terms = ::ScholarsArchive::ConferenceTerms.base_terms + ::ScholarsArchive::DefaultTerms.base_terms
      self.required_fields += %i[degree_level degree_name degree_field degree_grantors graduation_year]

      def primary_terms
        ::ScholarsArchive::ConferenceTerms.primary_terms | super
      end

      def secondary_terms
        t = ::ScholarsArchive::ConferenceTerms.secondary_terms
        t << ::ScholarsArchive::ConferenceTerms.admin_terms if current_ability.current_user.admin?
        t.flatten
      end
    end
  end
end