# frozen_string_literal: true

module ScholarsArchive
  # Label parser
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

    # METHOD: Add in a method to parse out value in the location string w/ uris
    def self.location_parse_uris(labels)
      # CHECK: Check to make sure the labels are not blank
      labels ||= []

      # PARSE: Call parse label with uris
      labels = parse_label_uris(labels)

      # FETCH: Fetch content out of the array hash
      labels.each_with_index do |val, ind|
        # ACCESS: Access the copy label content and split on ','
        str_arr = val['label'].split(',')

        # GET: Fetch the new string value
        new_loc_str = string_parse(str_arr)

        # ASSIGN: Assign the new value into the labels
        labels[ind]['label'] = new_loc_str
      end

      # RETURN: Return back the new string in labels
      labels
    end

    # METHOD: Add in a method to parse out value in the location string w/ labels only
    def self.location_parse_labels(labels)
      # CHECK: Check to make sure the labels are not blank
      labels ||= []

      # FETCH: Fetch content out of the array hash
      labels.each_with_index do |val, ind|
        # ACCESS: Access the copy label content and split on ','
        str_arr = val.split(',')

        # GET: Fetch the new string value
        new_loc_str = string_parse(str_arr)

        # ASSIGN: Assign the new value into the labels
        labels[ind] = new_loc_str
      end

      # RETURN: Return back the new string in labels
      labels
    end

    private

    def self.strip_uri(label)
      items = build_array(label)
      items[0...-1].join('$')
    end

    def self.strip_label(label)
      items = build_array(label)
      items.last
    end

    def self.build_array(label)
      label&.split('$') || []
    end

    # METHOD: Get the array, parse, and concat the string into a new location string
    def self.string_parse(str_arr)
      # CREATE: A str variable to return
      new_str = ''

      # CONDITION: Loop through and check the criteria to get new string display
      str_arr.each_with_index do |v, i|
        next if v == ' ' || i == (str_arr.length - 1)

        new_str += v
        new_str += ',' if i != str_arr.length - 2
      end

      # DOUBLE CHECK: Make sure at the end of the string there are now ','
      new_str = new_str.gsub(',', '') if new_str[-1] == ','

      # RETURN: Return the new string value
      new_str
    end
  end
end
