Bulkrax.setup do |config|
  config.parsers -= [
    { name: "OAI - Dublin Core", class_name: "Bulkrax::OaiDcParser", partial: "oai_fields" },
    { name: "OAI - Qualified Dublin Core", class_name: "Bulkrax::OaiQualifiedDcParser", partial: "oai_fields" },
    { name: "Bagit", class_name: "Bulkrax::BagitParser", partial: "bagit_fields" },
    { name: "XML", class_name: "Bulkrax::XmlParser", partial: "xml_fields" }
  ]

  config.field_mappings['Bulkrax::CsvParser'] = {
    'bulkrax_identifier' => { from: ['bulkrax_identifier'], source_identifier: true },
    'parents' => { from: ['parents'], related_parents_field_mapping: true, split: true, join: true},
    'children' => { from: ['children'], related_children_field_mapping: true, split: true },

    # from DefaultMetadata
    # no split here, let parser handle multiple values
    'nested_ordered_abstract' => { from: ['abstract'], parsed: true },
    'abstract' => { excluded: true },
    'academic_affiliation' => { from: ['academic_affiliation'], split: '\|' },
    # no split here, let parser handle multiple values
    'nested_ordered_additional_information' => { from: ['additional_information'], parsed: true },
    'additional_information' => { excluded: true },
    'alternative_title' => { from: ['alternative_title'], split: true },
    'based_near' => { from: ['based_near', 'location'], split: true },
    'bibliographic_citation' => { from: ['bibliographic_citation'] },
    'conference_location' => { from: ['conference_location'] },
    'conference_name' => { from: ['conference_name'] },
    'conference_section' => { from: ['conference_section'] },
    # no split here, let parser handle multiple values
    'nested_ordered_contributor' => { from: ['contributor'], parsed: true },
    'contributor' => { excluded: true },
    'contributor_advisor' => { from: ['contributor_advisor', 'advisor'], split: true },
    # no split here, let parser handle multiple values
    'nested_ordered_creator' => { from: ['creator'], parsed: true },
    'creator' => { excluded: true },
    # no split here, let parser handle multiple values
    'nested_ordered_title' => { from: ['title'], parsed: true },
    # first try adding this line gave error since no title meant invalid import
#    'title' => { excluded: true },
    'date_accepted' => { from: ['date_accepted'] },
    'date_available' => { from: ['date_available'] },
    'date_collected' => { from: ['date_collected'], split: true },
    'date_copyright' => { from: ['date_copyright'] },
    'date_created' => { from: ['date_created'] },
    'date_issued' => { from: ['date_issued'] },
    'date_reviewed' => { from: ['date_reviewed'] },
    'date_valid' => { from: ['date_valid'] },
    'degree_field' => { from: ['degree_field'], split: '\|' },
    'degree_level' => { from: ['degree_level'] },
    'degree_name' => { from: ['degree_name'] },
    'description' => { from: ['description'], split: true },
    'digitization_spec' => { from: ['digitization_spec'], split: true },
    'doi' => { from: ['doi'] },
    'embargo_reason' => { from: ['embargo_reason'] },
    'file_extent' => { from: ['file_extent'] },
    'file_format' => { from: ['file_format'] },
    'funding_body' => { from: ['funding_body'], split: '\|' },
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
    'language' => { from: ['language'], split: '\|' },
    'license' => { from: ['license'] },

#    'nested_geo' predicate: ::RDF::URI('https://purl.org/geojson/vocab#Feature'), class_name: NestedGeo
#    'nested_related_items' predicate: ::RDF::Vocab::DC.relation, class_name: NestedRelatedItems do |index|

    'other_affiliation' => { from: ['other_affiliation'], split: true },
    'part_of' => { from: ['part_of'], split: true },
    'peerreviewed' => { from: ['peerreviewed'] },
    'publisher' => { from: ['publisher'], split: true },
    'related_url' => { from: ['related_url'], split: true },
    'relative_path' => { from: ['relative_path'] },
    'replaces' => { from: ['replaces'] },
    'resource_type' => { from: ['resource_type'], split: true },
    'rights_statement' => { from: ['rights_statement'] },
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
  config.import_path = '/data/tmp/shared/imports'

  # Path to store exports before download
  config.export_path = '/data/tmp/shared/exports'

  config.fill_in_blank_source_identifiers = ->(obj, index) { "#{obj.importerexporter.id}-#{index}" }

  # adding to retain Hyrax 3 support
  config.object_factory = Bulkrax::ObjectFactory
end

Bulkrax::ApplicationMatcher.class_eval do
  # add nested_ordered fields to the parsed_fields
  class_attribute :parsed_fields, instance_writer: false, default: ['remote_files', 'language', 'subject', 'types', 'model', 'resource_type', 'format_original',
                                                                    'nested_ordered_title', 'nested_ordered_creator', 'nested_ordered_contributor',
                                                                    'nested_ordered_abstract', 'nested_ordered_additional_information']
end

Bulkrax::EntriesController.class_eval do
  def show
    if params[:importer_id].present?
      show_importer
      console
    elsif params[:exporter_id].present?
      show_exporter
    end
  end
end

Bulkrax::CsvEntry.class_eval do
  # check for empty vals: unless data.blank?
  def build_value(key, value)
    return unless hyrax_record.respond_to?(key.to_s)

    data = hyrax_record.send(key.to_s)

    if data.is_a?(ActiveTriples::Relation)
      if value['join']
          self.parsed_metadata[key_for_export(key)] = data.map { |d| prepare_export_data(d) }.join(Bulkrax.multi_value_element_join_on).to_s
      else
        case key
        when 'nested_ordered_title'
          data.sort_by{|k,v| k.index.first}.each do |d|
            self.parsed_metadata["#{key_for_export(key)}_#{d.index.first}"] = prepare_export_data(d.title.first)
          end
        when 'nested_ordered_creator'
          data.sort_by{|k,v| k.index.first}.each do |d|
            self.parsed_metadata["#{key_for_export(key)}_#{d.index.first}"] = prepare_export_data(d.creator.first)
          end
        when 'nested_ordered_contributor'
          data.sort_by{|k,v| k.index.first}.each do |d|
            self.parsed_metadata["#{key_for_export(key)}_#{d.index.first}"] = prepare_export_data(d.contributor.first)
          end
        when 'nested_ordered_abstract'
          data.sort_by{|k,v| k.index.first}.each do |d|
            self.parsed_metadata["#{key_for_export(key)}_#{d.index.first}"] = prepare_export_data(d.abstract.first)
          end
        when 'nested_ordered_additional_information'
          data.sort_by{|k,v| k.index.first}.each do |d|
            self.parsed_metadata["#{key_for_export(key)}_#{d.index.first}"] = prepare_export_data(d.additional_information.first)
          end
        else
          data.each_with_index do |d, i|
            self.parsed_metadata["#{key_for_export(key)}_#{i + 1}"] = prepare_export_data(d)
          end
        end
      end
    else
      self.parsed_metadata[key_for_export(key)] = prepare_export_data(data) unless data.blank?
    end
  end

  # changing call from member_work_ids to member_ids as the former does not return results
  # removing in_work_ids as redundant, member_of_work_ids works for both works and filesets
  # removing file_set_ids as redundant, member_ids returns both child works and filesets
  def build_relationship_metadata
    # Includes all relationship methods for all exportable record types (works, Collections, FileSets)
    relationship_methods = {
      related_parents_parsed_mapping => %i[member_of_collection_ids member_of_work_ids],
      related_children_parsed_mapping => %i[member_collection_ids member_ids]
    }

    relationship_methods.each do |relationship_key, methods|
      next if relationship_key.blank?

      values = []
      methods.each do |m|
        values << hyrax_record.public_send(m) if hyrax_record.respond_to?(m)
      end
      values = values.flatten.uniq
      next if values.blank?

      handle_join_on_export(relationship_key, values, mapping[related_parents_parsed_mapping]['join'].present?)
    end
  end
end

Bulkrax::ObjectFactory.class_eval do
  def self.solr_name(field_name)
    if (defined?(Hyrax) && Hyrax.respond_to?(:index_field_mapper))
      Hyrax.index_field_mapper.solr_name(field_name)
    else
      ActiveFedora.index_field_mapper.solr_name(field_name)
    end
  end
end

# Sidebar for hyrax 3+ support
if Object.const_defined?(:Hyrax) && ::Hyrax::DashboardController&.respond_to?(:sidebar_partials)
  Hyrax::DashboardController.sidebar_partials[:repository_content] << "hyrax/dashboard/sidebar/bulkrax_sidebar_additions"
end
