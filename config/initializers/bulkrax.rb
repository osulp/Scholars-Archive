Bulkrax.setup do |config|

  config.parsers -= [
    { name: "OAI - Dublin Core", class_name: "Bulkrax::OaiDcParser", partial: "oai_fields" },
    { name: "OAI - Qualified Dublin Core", class_name: "Bulkrax::OaiQualifiedDcParser", partial: "oai_fields" },
    { name: "Bagit", class_name: "Bulkrax::BagitParser", partial: "bagit_fields" },
    { name: "XML", class_name: "Bulkrax::XmlParser", partial: "xml_fields" }
  ]


  config.field_mappings['Bulkrax::CsvParser'] = {
    'bulkrax_identifier' => { from: ['bulkrax_identifier'], source_identifier: true },

    # from DefaultMetadata
    'abstract' => { from: ['abstract'], split: true },
    'academic_affiliation' => { from: ['academic_affiliation'], split: true },
    'additional_information' => { from: ['additional_information'], split: true },
    'alternative_title' => { from: ['alternative_title'], split: true },
    'based_near' => { from: ['based_near', 'location'], split: true },
    'bibliographic_citation' => { from: ['bibliographic_citation'] },
    'conference_location' => { from: ['conference_location'] },
    'conference_name' => { from: ['conference_name'] },
    'conference_section' => { from: ['conference_section'] },
    'contributor' => { from: ['contributor'], split: true },
    'contributor_advisor' => { from: ['contributor_advisor', 'advisor'], split: true },
    'creator' => { from: ['creator'], split: true },
    'date_accepted' => { from: ['date_accepted'] },
    'date_available' => { from: ['date_available'] },
    'date_collected' => { from: ['date_collected'], split: true },
    'date_copyright' => { from: ['date_copyright'] },
    'date_created' => { from: ['date_created'] },
    'date_issued' => { from: ['date_issued'] },
    'date_reviewed' => { from: ['date_reviewed'] },
    'date_valid' => { from: ['date_valid'] },
    'degree_field' => { from: ['degree_field'], split: true },
    'degree_level' => { from: ['degree_level'] },
    'degree_name' => { from: ['degree_name'] },
    'description' => { from: ['description'], split: true },
    'digitization_spec' => { from: ['digitization_spec'], split: true },
    'doi' => { from: ['doi'] },
    'embargo_reason' => { from: ['embargo_reason'] },

    'file_extent' => { from: ['file_extent'] },
    'file_format' => { from: ['file_format'] },
    'funding_body' => { from: ['funding_body'], split: true },
    'funding_statement' => { from: ['funding_statement'], split: true },
    'hydrologic_unit_code' => { from: ['hydrologic_unit_code'], split: true },
    'identifier' => { from: ['identifier'], split: true },
    'identifier_uri' => { from: ['identifier_uri'], split: true },
    'import_url' => { from: ['import_url'] },
    'in_series' => { from: ['in_series'], split: true },
    'isbn' => { from: ['isbn'], split: true },
    'issn' => { from: ['issn'], split: true },
    'keyword' => { from: ['keyword'], split: true },
    'label' => { from: ['label'] },
    'language' => { from: ['language'], split: true },
    'license' => { from: ['license'] },

#    'nested_geo' predicate: ::RDF::URI('https://purl.org/geojson/vocab#Feature'), class_name: NestedGeo
#    'nested_related_items' predicate: ::RDF::Vocab::DC.relation, class_name: NestedRelatedItems do |index|
#    'nested_ordered_creator' predicate: ::RDF::Vocab::DC11.creator, class_name: NestedOrderedCreator do |index|
#    'nested_ordered_title' predicate: ::RDF::Vocab::DC11.title, class_name: NestedOrderedTitle do |index|

    'other_affiliation' => { from: ['other_affiliation'], split: true },

      # accessor value used by AddOtherFieldOptionActor to persist "Other" values provided by the user
#      attr_accessor :other_affiliation_other

    'part_of' => { from: ['part_of'], split: true },
    'peerreviewed' => { from: ['peerreviewed'] },
    'publisher' => { from: ['publisher'], split: true },
    'related_url' => { from: ['related_url'], split: true },

    'relative_path' => { from: ['relative_path'] },
    'replaces' => { from: ['replaces'] },
    'resource_type' => { from: ['resource_type'], split: true },
    'rights_statement' => { from: ['rights_statement'], split: true },
    'source' => { from: ['source'], split: true },
    'subject' => { from: ['subject'], split: true },
    'tableofcontents' => { from: ['tableofcontents'], split: true },
    'documentation' => { from: ['documentation'], split: true },
    'accessibility_feature' => { from: ['accessibility_feature'], split: true },
    'accessibility_summary' => { from: ['accessibility_summary'], split: true },


# from article_metadata:

    'editor' => { from: ['editor'], split: true },
    'has_journal' => { from: ['has_journal'] },
    'has_number' => { from: ['has_number'] },
    'has_volume' => { from: ['has_volume'] },
    'is_referenced_by' => { from: ['is_referenced_by'], split: true },
    'web_of_science_uid' => { from: ['web_of_science_uid'] },

# from etd_metadata:

    'contributor_committeemember' => { from: ['contributor_committeemember'], split: true },
    'degree_discipline' => { from: ['degree_discipline'], split: true },
    'degree_grantors' => { from: ['degree_grantors'] },
    'graduation_year' => { from: ['graduation_year'] },

# from oer_metadata:
    'interactivity_type' => { from: ['interactivity_type'], split: true },
    'is_based_on_url' => { from: ['is_based_on_url'], split: true },
    'learning_resource_type' => { from: ['learning_resource_type'], split: true },
    'time_required' => { from: ['time_required'], split: true },
    'typical_age_range' => { from: ['typical_age_range'], split: true },
    'duration' => { from: ['duration'], split: true },

  }



# :nested_ordered_abstract
# :nested_ordered_additional_information
# :nested_ordered_contributor

# exclude:
# dspace_collection
# dspace_community

# question:
# file_extent
# file_format

# other_affiliation_other
# degree_grantors_other




config.field_mappings['Bulkrax::OaiDcParser'] = {
  "contributor" => { from: ["contributor"] },
  "creator" => { from: ["creator"], join: true },
  "date_created" => { from: ["date"] },
  "description" => { from: ["description"] },
  "identifier" => { from: ["identifier"] },
  "language" => { from: ["language"], parsed: true },
  "publisher" => { from: ["publisher"] },
  "related_url" => { from: ["relation"] },
  "rights_statement" => { from: ["rights"] },
  "license" => { from: ["license"], split: '\|' }, # some characters may need to be escaped
  "source" => { from: ["source"] },
  "subject" => { from: ["subject"], parsed: true },
  "title" => { from: ["title"] },
  "resource_type" => { from: ["type"], parsed: true },
  "remote_files" => { from: ["thumbnail_url"], parsed: true }
}






  # WorkType to use as the default if none is specified in the import
  # Default is the first returned by Hyrax.config.curation_concerns
  config.default_work_type = 'Default'

  # Path to store pending imports
  config.import_path = '/tmp/imports'

  # Path to store exports before download
  config.export_path = '/tmp/exports'

  config.fill_in_blank_source_identifiers = ->(obj, index) { "#{obj.importerexporter.id}-#{index}" }

  # adding to retain Hyrax 3 support
  config.object_factory = Bulkrax::ObjectFactory

end

# Sidebar for hyrax 3+ support
if Object.const_defined?(:Hyrax) && ::Hyrax::DashboardController&.respond_to?(:sidebar_partials)
  Hyrax::DashboardController.sidebar_partials[:repository_content] << "hyrax/dashboard/sidebar/bulkrax_sidebar_additions"
end
