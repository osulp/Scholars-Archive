# frozen_string_literal: true

module ScholarsArchive
  # Provide select options for the degree_fields
  class DegreeFieldService < Hyrax::QaSelectService
    def initialize
      super('degree_fields')
    end

    def all_labels(values)
      @authority.all.select { |r| values.include?(r[:id]) }.map { |hash| hash['label'] }
    end

    def select_sorted_active_options
      select_active_options.sort
    end

    def select_sorted_all_options
      select_all_options.sort << other_option
    end

    def other_option
      %w[Other Other]
    end

    def select_sorted_current_options
      select_sorted_active_options.select { |active_option| EdtfDateCompareService.includes_last_five_years?(active_option) }
    end

    def select_sorted_current_options_truncated
      truncate_date(select_sorted_current_options) << other_option
    end

    def select_sorted_all_options_truncated
      truncate_date(select_sorted_all_options)
    end

    private

    def truncate_date(options)
      options.map { |option| [option.first.split(' - ').first, option.second] }
    end
  end
end
