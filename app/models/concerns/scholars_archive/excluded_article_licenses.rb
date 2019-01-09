# frozen_string_literal: true

module ScholarsArchive
  # excluded article licenses
  module ExcludedArticleLicenses
    extend ActiveSupport::Concern

    included do
      def excluded_licenses
        []
      end
    end
  end
end
