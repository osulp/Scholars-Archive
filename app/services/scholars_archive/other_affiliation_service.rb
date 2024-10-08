# frozen_string_literal: true

module ScholarsArchive
  # Provide select options for other_affiliation field
  class OtherAffiliationService < Hyrax::QaSelectService
    def initialize
      super('other_affiliation')
    end

    def all_labels(values)
      @authority.all.select { |r| values.include?(r[:id]) }.map { |hash| hash['label'] }
    end

    def other_option
      %w[Other Other]
    end

    def select_sorted_all_options
      select_all_options.sort << other_option
    end

    def select_sorted_active_options
      select_active_options.sort << other_option
    end
  end
end
