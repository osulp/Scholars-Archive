module ScholarsArchive
  class LabelParserService
    def self.parse(labels)
      labels ||= []
      parsed_labels = []
      labels.each do |label|
        parsed_labels << strip_uri(label)
      end
      parsed_labels
    end

    private

    def self.strip_uri(label)
      label.split("$").first
    end
  end
end
