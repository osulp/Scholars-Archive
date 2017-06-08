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

  def nested_geo
    self[Solrizer.solr_name('nested_geo_label')]
  end

  solrized_methods [
      'academic_affiliation',
      'other_affiliation',
      'date_accepted',
      'rights_statement',
      'date_available',
      'date_collected',
      'date_copyright',
      'date_issued',
      'date_valid',
      'replaces',
      'doi',
      'alt_title',
      'abstract',
      'hydrologic_unit_code',
      'funding_body',
      'funding_statement',
      'in_series',
      'tableofcontents',
      'bibliographic_citation',
      'peerreviewed',
      'additional_information',
      'digitization_spec',
      'file_extent',
      'file_format',
      'dspace_community',
      'dspace_collection',
      'contributor_advisor',
      'contributor_committeemember',
      'degree_discipline',
      'degree_field',
      'degree_grantors',
      'degree_level',
      'degree_name',
      'graduation_year',
      'time_required',
      'typical_age_range',
      'learning_resource_type',
      'resource_type',
      'interactivity_type',
      'is_based_on_url',
      'is_referenced_by',
      'has_journal',
      'has_volume',
      'has_number',
      'relation',
      'conference_location',
      'conference_name',
      'conference_section',
      'editor',
      'isbn'
                   ]

end
