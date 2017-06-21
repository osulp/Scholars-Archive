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
     solr_doc['rights_statement_label_ssim'] = ScholarsArchive::RightsStatementService.new.all_labels(object.rights_statement)
     solr_doc['license_label_ssim'] = ScholarsArchive::LicenseService.new.all_labels(object.license)
     solr_doc['language_label_ssim'] = ScholarsArchive::LanguageService.new.all_labels(object.language)

     solr_doc['rights_statement_label_tesim'] = ScholarsArchive::RightsStatementService.new.all_labels(object.rights_statement)
     solr_doc['license_label_tesim'] = ScholarsArchive::LicenseService.new.all_labels(object.license)
     solr_doc['language_label_tesim'] = ScholarsArchive::LanguageService.new.all_labels(object.language)
   end
  end
end
