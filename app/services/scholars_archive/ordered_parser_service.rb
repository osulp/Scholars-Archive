module ScholarsArchive
  class OrderedParserService
    def self.parse(labels)
      labels ||= []
      sorted_labels = labels.map{ |label| build_array(label)}.sort_by{ |array| array[1] }.map{ |array| array[0] }
    end

    private

    def self.build_array(label)
      [label.split("$").first, label.split("$").second]
    end
  end
end