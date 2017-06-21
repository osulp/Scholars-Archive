module ScholarsArchive
  # Provide select options for the license (dcterms:rights) field
  class LanguageService < Hyrax::QaSelectService
    def initialize
      super('language')
    end

    def all_labels(values)
      @authority.all.select { |r| values.include?(r[:id]) }.map { |hash| hash['label'] }
    end
  end
end
