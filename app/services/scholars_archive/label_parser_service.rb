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
      items = build_array(label)
      drop_last(items).join('$')
    end

    def self.strip_label(label)
      items = build_array(label)
      items.last
    end

    def self.build_array(label)
      label.split("$")
    end

    # Returns an array except the last item. Returns [] if items is nil.
    #
    # ==== Example
    #
    # input: ["hello","world","hola","mundo"]
    # output: ["hello","world","hola"]
    def self.drop_last(items)
      items.present? ? items[0...-1] : []
    end
  end
end
