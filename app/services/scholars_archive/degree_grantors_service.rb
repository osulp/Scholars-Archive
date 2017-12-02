module ScholarsArchive
  # Provide select options for the degree_grantors field
  class DegreeGrantorsService < Hyrax::QaSelectService
    def initialize
      super('degree_grantors')
    end

    def select_sorted_all_options
      select_all_options.sort
    end
  end
end
