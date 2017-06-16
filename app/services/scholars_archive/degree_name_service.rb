module ScholarsArchive
  # Provide select options for the degree_levels (untl:degree-information/#level) field
  class DegreeNameService < Hyrax::QaSelectService
    def initialize
      super('degree_name')
    end
  end
end
