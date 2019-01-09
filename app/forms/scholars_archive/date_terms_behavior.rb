# frozen_string_literal: true

module ScholarsArchive
  # behavior for date terms
  module DateTermsBehavior
    extend ActiveSupport::Concern

    included do
      def date_terms
        super
      end
    end
  end
end
