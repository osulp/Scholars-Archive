module ScholarsArchive
  class LabelAndOrderedParserService
    def self.parse(labels)
      labels ||= []
      parsed_labels = []
      labels.each do |label|
        parsed_labels << index_label(label)
      end
      parsed_labels = labels.map{ |label| parse_index(label)}.sort_by{ |array| array[1] }.map{ |array| array[0] }
    end

    def self.parse_label_uris(labels)
      labels ||= []
      parsed_label_uris = []
      labels.each do |label|
        parsed_label_uris << { 'label' => extract_label(label), 'uri' => extract_uri(label), 'index' => extract_index(label) }
      end
      parsed_label_uris.sort_by { |hash| hash['index'] }.select { |hash| !hash["label"].empty? } 
    end

    private

    def self.extract_label(label)
      items = build_array(label)
      drop_last_two(items).join('$')
    end

    def self.extract_uri(label)
      build_array(label).second_to_last
    end

    def self.extract_index(label)
      build_array(label).last
    end

    def self.index_label(label)
      "#{label.split('$').first}$#{label.split('$').last}"
    end

    def self.build_array(label)
      label.split("$")
    end

    def self.parse_index(label)
      [extract_label(label), extract_index(label)]
    end

    # Returns an array except the last two items. Returns [] if items is nil.
    #
    # ==== Example
    #
    # input: ["hello","world","hola","mundo"]
    # output: ["hello", "world"]
    def self.drop_last_two(items)
      items.present? ? items[0...-2] : []
    end
  end
end
