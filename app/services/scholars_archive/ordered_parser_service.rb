# frozen_string_literal: true

module ScholarsArchive
  # Order parser
  class OrderedParserService
    def self.parse(labels)
      labels ||= []
      labels.map { |label| parse_index(label) }.sort_by { |array| array[1].to_i }.map { |array| array[0] }
    end

    def self.build_array(label)
      label&.split('$') || []
    end

    def self.parse_index(label)
      items = build_array(label)
      [items[0...-1].join('$'), items.last]
    end
  end
end
