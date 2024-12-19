# frozen_string_literal: true

module ScholarsArchive
  # This module can be mixed in on an indexer in order to combine date fields into one indexed field
  module IndexesCombinedSortDate
    def index_combined_date_field(object, solr_doc)
      date = edtf_sorting_date(object)
      # Grab the first value if it's a range
      date = date.first if date.instance_of? EDTF::Interval

      # Add date to index
      solr_doc['date_sort_combined_dtsi'] = date
    end

    private

    # Get the date for the date created sorting as an EDTF object
    def edtf_sorting_date(object)
      # Figure out which date to use
      date = if object.respond_to?(:date_issued) && object.date_issued.present?
               object.date_issued
             elsif object.respond_to?(:date_created) && object.date_created.present?
               object.date_created
             elsif object.respond_to?(:date_copyright) && object.date_copyright.present?
               object.date_copyright
             end

      # Sometimes the date is multivalue. Convert to array, pick the first, and parse for EDTF
      # If it doesn't parse, we get nil and just don't index for sorting
      Date.edtf(Array(date).first)
    end
    # rubocop:enable Metrics/AbcSize
  end
end
