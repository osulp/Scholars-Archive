# frozen_string_literal: true

class ArticleIndexer < DefaultWorkIndexer
  self.stored_and_facetable_fields += %i[editor has_volume has_number conference_name conference_section conference_location has_journal is_referenced_by isbn]
  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include ScholarsArchive::IndexesLinkedMetadata

  # Uncomment this block if you want to add custom indexing behavior:
  # def generate_solr_document
  #  super.tap do |solr_doc|
  #    solr_doc['my_custom_field_ssim'] = object.my_custom_property
  #  end
  # end
end
