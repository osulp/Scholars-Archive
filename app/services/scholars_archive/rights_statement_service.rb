# frozen_string_literal: true

module ScholarsArchive
  # Provide select options for the copyright status (edm:rights) field
  class RightsStatementService < Hyrax::QaSelectService
    def initialize
      super('rights_statements')
    end

    def all_labels(values)
      authority.all.select { |r| values.include?(r[:id]) }.map { |hash| hash['label'] }
    end
  end
end
