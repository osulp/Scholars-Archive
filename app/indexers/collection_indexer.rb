# frozen_string_literal: true

# indexes collection metadata
class CollectionIndexer < Hyrax::CollectionWithBasicMetadataIndexer
  include ScholarsArchive::IndexesCombinedSortDate

  # Uncomment this block if you want to add custom indexing behavior:
  def generate_solr_document
    super.tap do |solr_doc|
      index_combined_date_field(object, solr_doc)
    end
  end
end
