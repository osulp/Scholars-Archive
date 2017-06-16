module ScholarsArchive
  # Provide select options for the degree_fields
  class DegreeField < Hyrax::QaSelectService
    def initialize
      super('degree_field')
    end
  end
end
