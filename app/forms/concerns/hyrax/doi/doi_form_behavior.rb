# frozen_string_literal: true
module Hyrax
  module DOI
    module DOIFormBehavior
      extend ActiveSupport::Concern

      included do
        self.terms += [:datacite_doi]

        delegate :datacite_doi, to: :model
      end

      def secondary_terms
        super - [:datacite_doi]
      end
    end
  end
end