# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior


  # self.unique_key = 'id'

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

  def date_accepted
    self[Solrizer.solr_name('date_accepted')]
  end

  def date_available
    self[Solrizer.solr_name('date_available')]
  end

  def date_collected
    self[Solrizer.solr_name('date_collected')]
  end

  def date_copyright
    self[Solrizer.solr_name('date_copyright')]
  end

  def date_issued
    self[Solrizer.solr_name('date_issued')]
  end

  def date_valid
    self[Solrizer.solr_name('date_valid')]
  end

  def replaces
    self[Solrizer.solr_name('replaces')]
  end

  def doi
    self[Solrizer.solr_name('doi')]
  end

  def alt_title
    self[Solrizer.solr_name('alt_title')]
  end

  def abstract
    self[Solrizer.solr_name('abstract')]
  end

  def hydrologic_unit_code
    self[Solrizer.solr_name('hydrologic_unit_code')]
  end

  def funding_body
    self[Solrizer.solr_name('funding_body')]
  end
  
  def funding_statement
    self[Solrizer.solr_name('funding_statement')]
  end

  def in_series
    self[Solrizer.solr_name('in_series')]
  end

  def tableofcontents
    self[Solrizer.solr_name('tableofcontents')]
  end

  def bibliographic_citation
    self[Solrizer.solr_name('bibliographic_citation')]
  end

  def peerreviewed
    self[Solrizer.solr_name('peerreviewed')]
  end

  def additional_information
    self[Solrizer.solr_name('additional_information')]
  end

  def digitization_spec
    self[Solrizer.solr_name('digitization_spec')]
  end 

  def file_extent
    self[Solrizer.solr_name('file_extent')]
  end

  def file_format
    self[Solrizer.solr_name('file_format')]
  end

  def dspace_community
    self[Solrizer.solr_name('dspace_community')]
  end
  
  def dspace_collection
    self[Solrizer.solr_name('dspace_collection')]
  end

  def contributor_advisor
    self[Solrizer.solr_name('contributor_advisor')]
  end

  def contributor_committeemember
    self[Solrizer.solr_name('contributor_committeemember')]
  end

  def degree_discipline
    self[Solrizer.solr_name('degree_discipline')]
  end

  def degree_field
    self[Solrizer.solr_name('degree_field')]
  end

  def degree_grantors
    self[Solrizer.solr_name('degree_grantors')]
  end
  
  def degree_level
    self[Solrizer.solr_name('degree_level')]
  end

  def degree_name
    self[Solrizer.solr_name('degree_name')]
  end
  
  def graduation_year
    self[Solrizer.solr_name('graduation_year')]
  end
end
