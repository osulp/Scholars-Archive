module ScholarsArchive
  class LabelAndOrderedParserService
    def self.parse(labels)
      labels ||= []
      labels.map{ |label| parse_index(label)}
            .sort_by{ |array| array[1].to_i }
            .map{ |array| array[0] }
    end

    def self.parse_label_uris(labels)
      labels ||= []
      parsed_label_uris = []
      labels.each do |label|
        parsed_label_uris << { 'label' => extract_label(label), 'uri' => extract_uri(label), 'index' => extract_index(label) }
      end
      parsed_label_uris.sort_by { |hash| hash['index'].to_i }.select { |hash| !hash["label"].empty? }
    end

    private

    def self.extract_label(label)
      items = build_array(label)
      items[0...-2].join('$')
    end

    def self.extract_uri(label)
      build_array(label).second_to_last
    end

    def self.extract_index(label)
      build_array(label).last
    end

    def self.build_array(label)
      label&.split('$') || []
    end

    def self.parse_index(label)
      [extract_label(label), extract_index(label)]
    end
  end
end
