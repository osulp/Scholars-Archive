module ScholarsArchive
  # Provide select options for the degree_fields
  class DegreeFieldService < Hyrax::QaSelectService
    def initialize
      super('degree_field')
    end
  end
end
