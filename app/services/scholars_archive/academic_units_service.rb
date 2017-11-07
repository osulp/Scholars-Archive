module ScholarsArchive
  # Provide select options for the license (dcterms:rights) field
  class AcademicUnitsService < Hyrax::QaSelectService
    def initialize
      super('academic_units')
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

    def select_sorted_current_options
      select_sorted_active_options.select { |active_option| EdtfDateCompareService.includes_last_five_years?(active_option) }
    end

    def select_sorted_current_options_truncated
      select_sorted_current_options.map {|option| [option.first.split(" - ").first, option.second]}
    end
  end
end
