class DefaultWorkIndexer < Hyrax::WorkIndexer
  class_attribute :stored_and_facetable_fields
  self.stored_and_facetable_fields = %i[doi rights_statement rights_statement_label abstract alt_title license license_label language_label based_near resource_type date_available date_copyright date_issued date_collected date_valid date_accepted replaces hydrologic_unit_code funding_body funding_statement in_series tableofcontents bibliographic_citation peerreviewed additional_information digitization_spec file_extent file_format dspace_community dspace_collection itemtype nested_geo]
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include Hyrax::IndexesLinkedMetadata


  # Uncomment this block if you want to add custom indexing behavior:
  def generate_solr_document
   super.tap do |solr_doc|
     rights_statement_labels = ScholarsArchive::RightsStatementService.new.all_labels(object.rights_statement)
     license_labels = ScholarsArchive::LicenseService.new.all_labels(object.license)
     language_labels = ScholarsArchive::LanguageService.new.all_labels(object.language)
     object.triple_powered_properties.each do |field|
       labels = ScholarsArchive::TriplePoweredService.new.fetch(object.send(field)) 
       solr_doc[field.to_s + '_label_ssim'] = labels
       solr_doc[field.to_s + '_label_tesim'] = labels
     end
     solr_doc['rights_statement_label_ssim'] = rights_statement_labels
     solr_doc['rights_statement_label_tesim'] = rights_statement_labels
     solr_doc['license_label_ssim'] = license_labels
     solr_doc['license_label_tesim'] = license_labels
     solr_doc['language_label_ssim'] = language_labels
     solr_doc['language_label_tesim'] = language_labels
   end
  end
end
