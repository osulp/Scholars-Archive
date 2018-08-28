module ScholarsArchive
  module HasNestedOrderedProperties
    extend ActiveSupport::Concern

    included do
      def to_s
        if title.present?
          title
        elsif nested_ordered_title.first.title.present?
          nested_ordered_title.select { |i| i.title.present? }.map{|i| (i.instance_of? NestedOrderedTitle) ? [i.title.first, i.index.first] : i }.select(&:present?).sort_by{ |array| array[1] }.map{ |array| array[0] }.first
        else
          'No Title'
        end
      end
    end
  end
end
