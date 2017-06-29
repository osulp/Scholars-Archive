# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior


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

  # Do content negotiation for AF models.

  use_extension( Hydra::ContentNegotiation )

  def self.solrized_methods(property_names)
    property_names.each do |property_name|
      define_method property_name.to_sym do
        self[Solrizer.solr_name(property_name)]
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
    ScholarsArchive::LabelParserService.parse(self['academic_affiliation_label_ssim'])
  end

  def other_affiliation_label
    ScholarsArchive::LabelParserService.parse(self['other_affiliation_label_ssim'])
  end

  def rights_statement_label
    self['rights_statement_label_ssim']
  end

  def language_label
    self['language_label_ssim']
  end

  def nested_geo
    self[Solrizer.solr_name('nested_geo_label', :symbol)] || []
  end

  solrized_methods [
      'abstract',
      'academic_affiliation',
      'additional_information',
      'alt_title',
      'bibliographic_citation',
      'conference_location',
      'conference_name',
      'conference_section',
      'contributor_advisor',
      'contributor_committeemember',
      'date_accepted',
      'date_available',
      'date_collected',
      'date_copyright',
      'date_issued',
      'date_valid',
      'degree_discipline',
      'degree_field',
      'degree_grantors',
      'degree_level',
      'degree_name',
      'digitization_spec',
      'doi',
      'dspace_community',
      'dspace_collection',
      'editor',
      'file_extent',
      'file_format',
      'funding_body',
      'funding_statement',
      'graduation_year',
      'has_journal',
      'has_number',
      'has_volume',
      'hydrologic_unit_code',
      'in_series',
      'interactivity_type',
      'is_based_on_url',
      'is_referenced_by',
      'isbn',
      'issn',
      'learning_resource_type',
      'other_affiliation',
      'replaces',
      'tableofcontents',
      'time_required',
      'typical_age_range'
  ]
end
