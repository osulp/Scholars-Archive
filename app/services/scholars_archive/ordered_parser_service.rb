module ScholarsArchive
  class OrderedParserService
    def self.parse(labels)
      labels ||= []
      sorted_labels = labels.map{ |label| parse_index(label)}.sort_by{ |array| array[1] }.map{ |array| array[0] }
    end

    private

    def self.build_array(label)
      label.split("$")
    end

    def self.parse_index(label)
      items = build_array(label)
      [drop_last(items).join('$'), items.last]
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