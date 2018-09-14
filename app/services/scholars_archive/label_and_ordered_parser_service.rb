module ScholarsArchive
  class LabelAndOrderedParserService
    def self.parse(labels)
      labels ||= []
      parsed_labels = []
      labels.each do |label|
        parsed_labels << index_label(label)
      end
      parsed_labels = labels.map{ |label| build_array(label)}.sort_by{ |array| array[1] }.map{ |array| array[0] }
    end

    def self.parse_label_uris(labels)
      labels ||= []
      parsed_label_uris = []
      labels.each do |label|
        parsed_label_uris << { 'label' => strip_uri(label), 'uri' => strip_label(label), 'index' => extract_index(label) }
      end
      parsed_label_uris.sort_by { |hash| hash['index'] }.select { |hash| !hash["label"].empty? } 
    end

    private

    def self.strip_uri(label)
      label.split("$").first
    end

    def self.strip_label(label)
      label.split("$").second
    end

    def self.extract_index(label)
      label.split('$').last
    end

    def index_label(label)
      "#{label.split('$').first}$#{label.split('$').last}"
    end

    def self.build_array(label)
      [label.split("$").first, label.split("$")[2]]
    end
  end
end
