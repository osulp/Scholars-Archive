# frozen_string_literal: true

module ScholarsArchive
  module ExcludedOerLicenses
    extend ActiveSupport::Concern

    included do
      def excluded_licenses
        []
      end
    end
  end
end
