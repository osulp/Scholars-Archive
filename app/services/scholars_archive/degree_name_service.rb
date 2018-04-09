module ScholarsArchive
  # Provide select options for the degree_names field
  class DegreeNameService < Hyrax::QaSelectService
    def initialize
      super('degree_name')
    end

    def select_sorted_active_options
      select_active_options.sort
    end

    def select_sorted_all_options
      select_all_options.sort
    end

  end
end
