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

end
