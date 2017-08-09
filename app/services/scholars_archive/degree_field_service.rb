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

    def select_sorted_current_options
      select_sorted_active_options.select { |active_option| EdtfDateCompareService.includes_last_five_years?(active_option) }
    end

  end
end
