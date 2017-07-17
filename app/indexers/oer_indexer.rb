class OerIndexer < DefaultWorkIndexer
  self.stored_and_facetable_fields += %i[is_based_on_url interactivity_type learning_resource_type typical_age_range time_required duration]
  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include Hyrax::IndexesLinkedMetadata


  # Uncomment this block if you want to add custom indexing behavior:
  # def generate_solr_document
  #  super.tap do |solr_doc|
  #    solr_doc['my_custom_field_ssim'] = object.my_custom_property
  #  end
  # end
end
