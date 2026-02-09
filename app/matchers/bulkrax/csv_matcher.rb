# frozen_string_literal: true

module Bulkrax
  # adds parse methods
  # note that the field also needs to be added to list, see the override for ApplicationMatcher in /config/initializers/bulkrax.rb
  class CsvMatcher < ApplicationMatcher
    def parse_nested_ordered_title(src)
      # split if multiple values, trim whitespace
      result = src.split('|').map!(&:strip)
      # build array of hash(es) for attributes with order preserved
      attr = []
      result.each_with_index do |r, i|
        attr << { index: i, title: r }
      end
      attr
    end

    def parse_nested_ordered_creator(src)
      # split if multiple values, trim whitespace
      result = src.split('|').map!(&:strip)
      # build array of hash(es) for attributes with order preserved
      attr = []
      result.each_with_index do |r, i|
        attr << { index: i, creator: r }
      end
      attr
    end

    def parse_nested_ordered_contributor(src)
      # split if multiple values, trim whitespace
      result = src.split('|').map!(&:strip)
      # build array of hash(es) for attributes with order preserved
      attr = []
      result.each_with_index do |r, i|
        attr << { index: i, contributor: r }
      end
      attr
    end

    def parse_nested_ordered_abstract(src)
      # split if multiple values, trim whitespace
      result = src.split('|').map!(&:strip)
      # build array of hash(es) for attributes with order preserved
      attr = []
      result.each_with_index do |r, i|
        attr << { index: i, abstract: r }
      end
      attr
    end

    def parse_nested_ordered_additional_information(src)
      # split if multiple values, trim whitespace
      result = src.split('|').map!(&:strip)
      # build array of hash(es) for attributes with order preserved
      attr = []
      result.each_with_index do |r, i|
        attr << { index: i, additional_information: r }
      end
      attr
    end
  end
end
