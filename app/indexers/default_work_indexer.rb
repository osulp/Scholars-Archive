# frozen_string_literal: true

# indexes default metadata
class DefaultWorkIndexer < Hyrax::WorkIndexer
  class_attribute :stored_and_facetable_fields
  self.stored_and_facetable_fields = %i[doi rights_statement rights_statement_label abstract alt_title license license_label language_label based_near based_near_linked resource_type date_available date_copyright date_issued date_collected date_valid date_reviewed date_accepted degree_level degree_name degree_field replaces hydrologic_unit_code funding_body funding_statement in_series tableofcontents bibliographic_citation peerreviewed additional_information digitization_spec file_extent file_format dspace_community dspace_collection itemtype nested_geo peerreviewed_label conference_name conference_section conference_location contributor_advisor]
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
      triple_powered_properties_for_solr_doc(object, solr_doc)
      solr_doc['based_near_linked_ssim'] = object.based_near.each.map { |location| location.solrize.second[:label] }
      solr_doc['based_near_linked_tesim'] = object.based_near.each.map { |location| location.solrize.second[:label] }
      solr_doc['rights_statement_label_ssim'] = rights_statement_labels
      solr_doc['rights_statement_label_tesim'] = rights_statement_labels
      solr_doc['license_label_ssim'] = license_labels
      solr_doc['license_label_tesim'] = license_labels
      solr_doc['language_label_ssim'] = language_labels
      solr_doc['language_label_tesim'] = language_labels
      solr_doc['peerreviewed_label_ssim'] = peerreviewed_label
      solr_doc['peerreviewed_label_tesim'] = peerreviewed_label
      solr_doc['replaces_ssim'] = object.replaces
      title_for_solr_doc(object, solr_doc)

      # Check if embargo is active
      if object&.embargo && object.embargo.active?
        embargo_date_range_string(solr_doc, object.embargo.create_date.to_date, object.embargo.embargo_release_date.to_date)
      elsif object&.embargo && !object.embargo.active?
        embargo_date_range_string(solr_doc, object.embargo.create_date.to_date, object.embargo.embargo_history.first.split('.').first.split(' ').last)
      end
    end
  end

  def embargo_date_range_string(solr_doc, start_date, end_date)
    solr_doc['embargo_date_range_ssim'] = "#{start_date} to #{end_date}"
  end

  def title_for_solr_doc(object, solr_doc)
    if object.nested_ordered_title.first.present?
      solr_doc['title_ssi'] = object.nested_ordered_title.first.title.first
    else
      solr_doc['title_ssi'] = object.title.first
    end
  end

  def triple_powered_properties_for_solr_doc(object, solr_doc)
    object.triple_powered_properties.each do |o|
      labels = []
      if ScholarsArchive::FormMetadataService.multiple? object.class, o[:field]
        uris = object.send(o[:field])
        uris = object.send(o[:field]).reject { |u| u == 'Other' }

        # if multiple URIs, need to get top label for each one
        uris.each do |uri|
          labels << ScholarsArchive::TriplePoweredService.new.fetch_top_label(uri.lines.to_a, parse_date: o[:has_date])
        end
      else
        uris = Array(object.send(o[:field]))
        uris = Array(object.send(o[:field])).reject { |u| u == 'Other' }
        labels = ScholarsArchive::TriplePoweredService.new.fetch_top_label(uris, parse_date: o[:has_date])
      end
      solr_doc[o[:field].to_s + '_label_ssim'] = labels
      solr_doc[o[:field].to_s + '_label_tesim'] = labels
    end
    solr_doc
  end
end
