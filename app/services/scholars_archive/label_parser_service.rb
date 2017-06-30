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

    def self.parse_label_uris(labels)
      labels ||= []
      parsed_label_uris = []
      labels.each do |label|
        parsed_label_uris << { 'label' => strip_uri(label), 'uri' => strip_label(label) }
      end
      parsed_label_uris
    end

    private

    def self.strip_uri(label)
      label.split("$").first
    end

    def self.strip_label(label)
      label.split("$").second
    end
  end
end
