class DefaultWorkIndexer < Hyrax::WorkIndexer
  class_attribute :stored_and_facetable_fields
  self.stored_and_facetable_fields = %i[doi rights_statement rights_statement_label abstract alt_title license license_label language_label based_near resource_type date_available date_copyright date_issued date_collected date_valid date_reviewed date_accepted degree_level degree_name degree_field replaces hydrologic_unit_code funding_body funding_statement in_series tableofcontents bibliographic_citation peerreviewed additional_information digitization_spec file_extent file_format dspace_community dspace_collection itemtype nested_geo peerreviewed_label conference_location conference_name conference_section]
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include ScholarsArchive::IndexesLinkedMetadata


  # Uncomment this block if you want to add custom indexing behavior:
  def generate_solr_document
    super.tap do |solr_doc|
      rights_statement_labels = ScholarsArchive::RightsStatementService.new.all_labels(object.rights_statement)
      license_labels = ScholarsArchive::LicenseService.new.all_labels(object.license)
      language_labels = ScholarsArchive::LanguageService.new.all_labels(object.language)
      peerreviewed_label = ScholarsArchive::PeerreviewedService.new.all_labels(object.peerreviewed)
      degree_field_labels = ScholarsArchive::DegreeFieldService.new.all_labels(object.degree_field)
      object.triple_powered_properties.each do |o|
        if ScholarsArchive::FormMetadataService.multiple? object.class, o[:field]
          uris = object.send(o[:field])
          uris = object.send(o[:field]).reject { |u| u == "Other"}
          labels = ScholarsArchive::TriplePoweredService.new.fetch_all_labels(uris)
        else
          uris = Array(object.send(o[:field]))
          uris = Array(object.send(o[:field])).reject { |u| u == "Other" }
          labels = ScholarsArchive::TriplePoweredService.new.fetch_top_label(uris, parse_date: o[:has_date])
        end
        solr_doc[o[:field].to_s + '_label_ssim'] = labels
        solr_doc[o[:field].to_s + '_label_tesim'] = labels
      end

      solr_doc['rights_statement_label_ssim'] = rights_statement_labels
      solr_doc['rights_statement_label_tesim'] = rights_statement_labels
      solr_doc['degree_field_label_ssim'] = degree_field_labels
      solr_doc['degree_field_label_tesim'] = degree_field_labels
      solr_doc['license_label_ssim'] = license_labels
      solr_doc['license_label_tesim'] = license_labels
      solr_doc['language_label_ssim'] = language_labels
      solr_doc['language_label_tesim'] = language_labels
      solr_doc['peerreviewed_label_ssim'] = peerreviewed_label
      solr_doc['peerreviewed_label_tesim'] = peerreviewed_label
      solr_doc['replaces_ssim'] = object.replaces
      solr_doc['title_ssi'] = object.title.first
    end
  end
end
