# frozen_string_literal: true

module ScholarsArchive
  # Provide select options for the accessibility_feature field
  class AccessibilityFeatureService < Hyrax::QaSelectService
    def initialize
      super('accessibility_feature')
    end

    def all_labels(values)
      @authority.all.select { |r| values.include?(r[:id]) }.map { |hash| hash['label'] }
    end

    def select_sorted_active_options
      select_active_options.sort
    end

    def select_sorted_all_options
      select_all_options.sort
    end
  end
end
