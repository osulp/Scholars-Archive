module ScholarsArchive
  # Provide select options for the degree_levels (untl:degree-information/#level) field
  class DegreeLevelService < Hyrax::QaSelectService
    def initialize
      super('degree_level')
    end
  end
end
