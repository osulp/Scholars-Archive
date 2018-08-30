module ScholarsArchive
  module HasNestedOrderedProperties
    extend ActiveSupport::Concern

    included do

      def title
        ordered_titles.present? ? ordered_titles : super
      end

      def creator
        ordered_creators.present? ? ordered_creators : super
      end

      # Returns an array of only titles given an array of values that also
      # include indexes in the form [[title, index], ...].
      #
      # ==== Example
      #
      # input: [["My Title","0"], ["Another Tilte", "1"]]
      # output: [["My Title", "Another Title"]]
      def ordered_titles
        sort_titles_by_index.map{ |titles| titles.first }
      end

      def ordered_creators
        sort_creators_by_index.map{ |creators| creators.first }
      end

      # Returns a sorted array (by index value) of nested titles given an array with two
      # values per element in the form [[title, index],...].
      #
      # ==== Example
      #
      # input: [["Another Title", "1"], ["My Title", "0"]]
      # output: [["My Title", "0"], ["Another Title", "1"]]
      def sort_titles_by_index
        validate_titles.sort_by{ |titles| titles.second }
      end

      def sort_creators_by_index
        validate_creators.sort_by{ |creators| creators.second }
      end

      # Returns an array of items in the form [[title, index], ...] given an
      # array of items of type NestedOrderedTitle, excluding empty items, and invalid items
      # if any (nested items with no index or no title values).
      #
      # ==== Example
      #
      # input: [#<NestedOrderedTitle: ...>, #<NestedOrderedTitle: ...>, ""]
      # output: [["Another Title", "1"], ["My Title", "0"]]
      def validate_titles
        nested_ordered_title.select { |i| i.title.present? && i.index.present? }
          .map{|i| (i.instance_of? NestedOrderedTitle) ? [i.title.first, i.index.first] : [i] }
          .select(&:present?)
      end

      def validate_creators
        nested_ordered_creator.select { |i| i.creator.present? && i.index.present? }
          .map{|i| (i.instance_of? NestedOrderedCreator) ? [i.creator.first, i.index.first] : [i] }
          .select(&:present?)
      end
    end
  end
end
