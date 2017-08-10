module ScholarsArchive
  # Provide select options for the degree_levels (untl:degree-information/#level) field
  class DegreeLevelService < Hyrax::QaSelectService
    def initialize
      super('degree_level')
    end

    def select_sorted_all_options
      select_all_options.sort
    end
  end
end
