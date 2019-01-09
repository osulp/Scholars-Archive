# frozen_string_literal: true

module ScholarsArchive
  # excluded licenses
  module ExcludedOerLicenses
    extend ActiveSupport::Concern

    included do
      def excluded_licenses
        []
      end
    end
  end
end
