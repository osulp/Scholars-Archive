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
  end
end
