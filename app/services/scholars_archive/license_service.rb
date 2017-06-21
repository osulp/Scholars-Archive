module ScholarsArchive
  # Provide select options for the copyright status (edm:rights) field
  class LicenseService < Hyrax::QaSelectService
    def initialize
      super('licenses')
    end

    def all_labels(values)
      authority.all.select { |r| values.include?(r[:id]) }.map { |hash| hash["label"] }
    end
  end
end
