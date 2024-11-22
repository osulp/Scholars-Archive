# frozen_string_literal: true

# solr document object
class SolrDocument
  include Blacklight::Solr::Document
  include BlacklightOaiProvider::SolrDocument
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior
  # Add attributes for DOIs for hyrax-doi plugin.
  include Hyrax::DOI::SolrDocument::DOIBehavior
  # Add attributes for DataCite DOIs for hyrax-doi plugin.
  include Hyrax::DOI::SolrDocument::DataCiteDOIBehavior

  # .unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)
  use_extension(ScholarsArchive::Document::QualifiedDublinCore)

  # Do content negotiation for AF models.
  use_extension(Hydra::ContentNegotiation)

  def self.solrized_methods(property_names)
    property_names.each do |property_name|
      define_method property_name.to_sym do
        values = self["#{property_name}_tesim"]
        if values.respond_to?(:each)
          values.reject(&:blank?)
        else
          values
        end
      end
    end
  end

  def peerreviewed_label
    self['peerreviewed_label_ssim']
  end

  def license_label
    self['license_label_ssim']
  end

  def academic_affiliation_label
    ScholarsArchive::LabelParserService.parse_label_uris(self['academic_affiliation_label_ssim'])
  end

  def degree_field_label
    ScholarsArchive::LabelParserService.parse_label_uris(self['degree_field_label_ssim'])
  end

  def degree_grantors_label
    ScholarsArchive::LabelParserService.parse_label_uris(self['degree_grantors_label_ssim'])
  end

  def other_affiliation_label
    ScholarsArchive::LabelParserService.parse_label_uris(self['other_affiliation_label_ssim'])
  end

  def rights_statement_label
    self['rights_statement_label_ssim']
  end

  def language_label
    self['language_label_ssim']
  end

  def based_near_linked
    self['based_near_linked_ssim']
  end

  def based_near_linked_label
    ScholarsArchive::LabelParserService.location_parse_uris(self['based_near_linked_ssim'])
  end

  def embargo_date_range
    self['embargo_date_range_ssim']
  end

  # METHOD: A funding_body fetching label method
  def funding_body_label
    ScholarsArchive::LabelParserService.parse_label_uris(self['funding_body_linked_ssim']) || []
  end

  def nested_geo
    self['nested_geo_label_ssim'] || []
  end

  def nested_related_items_label
    ScholarsArchive::LabelAndOrderedParserService.parse_label_uris(self['nested_related_items_label_ssim']) || []
  end

  def nested_ordered_creator_label
    ScholarsArchive::OrderedParserService.parse(self['nested_ordered_creator_label_ssim']) || []
  end

  def nested_ordered_title_label
    ScholarsArchive::OrderedParserService.parse(self['nested_ordered_title_label_ssim']) || []
  end

  def title
    nested_ordered_title_label.present? ? nested_ordered_title_label : self['title_tesim'] || []
  end

  def creator
    nested_ordered_creator_label.present? ? nested_ordered_creator_label : self['creator_tesim'] || []
  end

  def additional_information
    nested_ordered_additional_information_label.present? ? nested_ordered_additional_information_label : self['additional_information_tesim'] || []
  end

  def nested_ordered_abstract_label
    ScholarsArchive::OrderedParserService.parse(self['nested_ordered_abstract_label_ssim']) || []
  end

  def nested_ordered_contributor_label
    ScholarsArchive::OrderedParserService.parse(self['nested_ordered_contributor_label_ssim']) || []
  end

  def nested_ordered_additional_information_label
    ScholarsArchive::OrderedParserService.parse(self['nested_ordered_additional_information_label_ssim']) || []
  end

  def system_created
    Time.parse self['system_create_dtsi']
  end

  # Dates & Times are stored in Solr as UTC but need to be displayed in local timezone
  def modified_date
    Time.parse(self['system_modified_dtsi']).in_time_zone.to_date
  end

  def create_date
    Time.parse(self['system_create_dtsi']).in_time_zone.to_date
  end

  def date_uploaded
    Time.parse(self['date_uploaded_dtsi']).in_time_zone.to_date
  end

  def date_modified
    Time.parse(self['date_modified_dtsi']).in_time_zone.to_date
  end

  solrized_methods %w[
    abstract
    academic_affiliation
    alternative_title
    bibliographic_citation
    conference_location
    conference_name
    conference_section
    contributor_advisor
    contributor_committeemember
    date_accepted
    date_available
    date_collected
    date_copyright
    date_issued
    date_valid
    date_reviewed
    degree_discipline
    degree_field
    degree_grantors
    degree_level
    degree_name
    digitization_spec
    doi
    dspace_community
    dspace_collection
    duration
    editor
    embargo_reason
    file_extent
    file_format
    funding_body
    funding_statement
    graduation_year
    has_journal
    has_number
    has_volume
    hydrologic_unit_code
    in_series
    interactivity_type
    is_based_on_url
    is_referenced_by
    isbn
    issn
    learning_resource_type
    other_affiliation
    replaces
    tableofcontents
    time_required
    typical_age_range
    documentation
    web_of_science_uid
    ext_relation
  ]

  field_semantics.merge!(
    contributor: %w[contributor_tesim editor_tesim contributor_advisor_tesim contributor_committeemember_tesim oai_academic_affiliation_label oai_other_affiliation_label],
    coverage: %w[based_near_label_tesim conferenceLocation_tesim],
    creator: 'creator_tesim',
    date: 'date_created_tesim',
    description: %w[description_tesim abstract_tesim],
    format: %w[file_extent_tesim file_format_tesim],
    identifier: 'oai_identifier',
    language: 'language_label_tesim',
    publisher: 'publisher_tesim',
    relation: 'oai_nested_related_items_label',
    rights: 'oai_rights',
    source: %w[source_tesim isBasedOnUrl_tesim],
    subject: %w[subject_tesim keyword_tesim],
    title: 'title_tesim',
    type: 'resource_type_tesim'
  )

  # Override SolrDocument hash access for certain virtual fields
  def [](key)
    return send(key) if %w[oai_academic_affiliation_label oai_other_affiliation_label oai_rights oai_identifier oai_nested_related_items_label].include?(key)

    super
  end

  def sets
    fetch('isPartOf', []).map { |m| ::OaiSet.new("isPartOf_ssim:#{m}") }
  end

  def oai_nested_related_items_label
    related_items = []
    nested_related_items_label.each do |r|
      related_items << "#{r['label']}: #{r['uri']}"
    end
    related_items
  end

  def oai_academic_affiliation_label
    aa_labels = []
    academic_affiliation_label.each do |a|
      aa_labels << a['label']
    end
    aa_labels
  end

  def oai_other_affiliation_label
    oa_labels = []
    other_affiliation_label.each do |o|
      oa_labels << o['label']
    end
    oa_labels
  end

  # Only return License if present, otherwise Rights
  def oai_rights
    license_label || rights_statement_label
  end

  def oai_identifier
    if self['has_model_ssim'].first.to_s == 'Collection'
      Hyrax::Engine.routes.url_helpers.url_for(only_path: false, action: 'show', host: CatalogController.blacklight_config.oai[:provider][:repository_url].gsub('/catalog/oai', ''), controller: 'hyrax/collections', id: id)
    else
      Rails.application.routes.url_helpers.url_for(only_path: false, action: 'show', host: CatalogController.blacklight_config.oai[:provider][:repository_url].gsub('/catalog/oai', ''), controller: "hyrax/#{self['has_model_ssim'].first.to_s.underscore.pluralize}", id: id)
    end
  end

  def abstract
    nested_ordered_abstract_label.present? ? nested_ordered_abstract_label : self['abstract_tesim'] || []
  end
end
