# frozen_string_literal: true

# solr document object
class SolrDocument
  include Blacklight::Solr::Document
  include BlacklightOaiProvider::SolrDocumentBehavior
  include Blacklight::Gallery::OpenseadragonSolrDocument
  include Hyrax::SolrDocumentBehavior

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued.
  use_extension(Blacklight::Document::DublinCore)
  use_extension(ScholarsArchive::Document::QualifiedDublinCore)
  use_extension(Hydra::ContentNegotiation)

  def self.solrized_methods(property_names)
    property_names.each do |property_name|
      define_method property_name.to_sym do
        values = self[Solrizer.solr_name(property_name)]
        if values.respond_to?(:each)
          values.reject(&:blank?)
        else
          values
        end
      end
    end
  end

  def self.solrized_methods_parsed(property_name)
    property_names.each do |property_name|
      define_method property_name.to_sym do
        case property_name
        when property_name.include?('ordered')
          values = ScholarsArchive::OrderedParserService.parse(self[Solrizer.solr_name(property_name, :symbol)]) || []
        when property_name.include?('related_items')
          values = ScholarsArchive::LabelAndOrderedParserService.parse_label_uris(self[Solrizer.solr_name(property_name, :symbol)]) || []
        when property_name.include?('degree') || property_name.include?('affiliation')
          values = ScholarsArchive::LabelParserService.parse_label_uris(self[Solrizer.solr_name(property_name, :symbol)]])
        else
          self[Solrizer.solr_name(property_name, :symbol)
        end
      end
    end
  end

  def nested_geo
    self[Solrizer.solr_name('nested_geo_label', :symbol)] || []
  end

  def title
     nested_ordered_title_label.present? ? nested_ordered_title_label : self[Solrizer.solr_name('title', :stored_searchable)] || []
  end

  def creator
     nested_ordered_creator_label.present? ? nested_ordered_creator_label : self[Solrizer.solr_name('creator', :stored_searchable)] || []
  end

  def additional_information
     nested_ordered_additional_information_label.present? ? nested_ordered_additional_information_label : self[Solrizer.solr_name('additional_information', :stored_searchable)] || []
  end

  def abstract
     nested_ordered_abstract_label.present? ? nested_ordered_abstract_label : self[Solrizer.solr_name('abstract', :stored_searchable)] || []
  end

  def system_created
    Time.parse self['system_create_dtsi']
  end

  solrized_methods_parsed %w[
    nested_ordered_additional_information_label
    nested_ordered_contributor_label
    nested_ordered_abstract_label
    nested_related_items_label
    nested_ordered_creator_label
    nested_ordered_title_label
    academic_affiliation_label
    other_affiliation_label
    degree_field_label
    degree_grantors_label
    rights_statement_label
    language_label
    based_near_linked
    embargo_date_range
    peer_reviewed_label
    license_label
  ]

  solrized_methods %w[
    abstract
    academic_affiliation
    alt_title
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
    web_of_science_uid
  ]

  field_semantics.merge!(
    contributor:  %w[contributor_tesim editor_tesim contributor_advisor_tesim contributor_committeemember_tesim oai_academic_affiliation_label oai_other_affiliation_label],
    coverage:     %w['based_near_label_tesim conferenceLocation_tesim],
    creator:      'creator_tesim',
    date:         'date_created_tesim',
    description:  %w['description_tesim abstract_tesim],
    format:       %w['file_extent_tesim file_format_tesim],
    identifier:   'oai_identifier',
    language:     'language_label_tesim',
    publisher:    'publisher_tesim',
    relation:     'oai_nested_related_items_label',
    rights:       'oai_rights',
    source:       %w[source_tesim isBasedOnUrl_tesim],
    subject:      %w[subject_tesim keyword_tesim],
    title:        'title_tesim',
    type:         'resource_type_tesim'
  )

  # Override SolrDocument hash access for certain virtual fields
  def [](key)
    return send(key) if %w[oai_academic_affiliation_label oai_other_affiliation_label oai_rights oai_identifier oai_nested_related_items_label].include?(key)

    super
  end

  def sets
    fetch('isPartOf', []).map { |m| BlacklightOaiProvider::Set.new("isPartOf_ssim:#{m}") }
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
      Hyrax::Engine.routes.url_helpers.url_for(only_path: false, action: 'show', host: CatalogController.blacklight_config.oai[:provider][:repository_url], controller: 'hyrax/collections', id: id)
    else
      Rails.application.routes.url_helpers.url_for(only_path: false, action: 'show', host: CatalogController.blacklight_config.oai[:provider][:repository_url], controller: "hyrax/#{self['has_model_ssim'].first.to_s.underscore.pluralize}", id: id)
    end
  end
end
