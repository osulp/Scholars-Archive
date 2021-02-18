# frozen_string_literal: true

module ScholarsArchive
  # This module can be mixed in on an indexer in order to combine date fields into one indexed field
  module IndexesCombinedSortDate
    def index_combined_date_field(object, solr_doc)
      # Figure out which date to use
      date = if object&.date_issued.present?
               Date.edtf(object.date_issued)
             elsif object&.date_created.present?
               Date.edtf(object.date_created)
             elsif object&.date_copyright.present?
               Date.edtf(object.date_copyright)
             end

      # Grab the first value if it's a range
      date = date.first if date.instance_of? EDTF::Interval

      # Add date to index
      solr_doc['date_sort_combined_dtsi'] = date
    end
  end
end
