# frozen_string_literal: true

module ScholarsArchive
  module ExcludedEtdLicenses
    extend ActiveSupport::Concern

    included do
      def excluded_licenses
        ['CC0 1.0 Universal']
      end
    end
  end
end
