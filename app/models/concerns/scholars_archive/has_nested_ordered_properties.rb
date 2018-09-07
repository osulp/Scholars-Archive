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

      def abstract
        ordered_abstracts.present? ? ordered_abstracts : super
      end

      def contributor
        ordered_contributors.present? ? ordered_contributors : super
      end

      def additional_information
        ordered_info.present? ? ordered_info : super
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

      def ordered_abstracts
        sort_abstracts_by_index.map{ |abstracts| abstracts.first }
      end

      def ordered_contributors
        sort_contributors_by_index.map{ |contributors| contributors.first }
      end

      def ordered_info
        sort_info_by_index.map{ |info| info.first }
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

      def sort_abstracts_by_index
        validate_abstracts.sort_by{ |abstracts| abstracts.second }
      end

      def sort_contributors_by_index
        validate_contributors.sort_by{ |contributors| contributors.second }
      end

      def sort_info_by_index
        validate_info.sort_by{ |info| info.second }
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

      def validate_abstracts
        nested_ordered_abstract.select do |i|
          i.present? if i.is_a? String 
          i.abstract.present? && i.index.present? if i.respond_to?(:abstract)
        end.map{|i| (i.instance_of? NestedOrderedAbstract) ? [i.abstract.first, i.index.first] : [i] }.select(&:present?)
      end

      def validate_contributors
        nested_ordered_contributor.select { |i| i.contributor.present? && i.index.present? }
          .map{|i| (i.instance_of? NestedOrderedContributor) ? [i.contributor.first, i.index.first] : [i] }
          .select(&:present?)
      end

      def validate_info
        nested_ordered_additional_information.select { |i| i.additional_information.present? && i.index.present? }
          .map{|i| (i.instance_of? NestedOrderedAdditionalInformation) ? [i.additional_information.first, i.index.first] : [i] }
          .select(&:present?)
      end
    end
  end
end
