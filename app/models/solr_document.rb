# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds CurationConcerns behaviors to the SolrDocument.
  include CurationConcerns::SolrDocumentBehavior
  # Adds Sufia behaviors to the SolrDocument.
  include Sufia::SolrDocumentBehavior



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

  def accepted
    Array(self[Solrizer.solr_name('accepted')]).first
  end

  def date
    Array(self[Solrizer.solr_name('date')]).first
  end

  def available
    Array(self[Solrizer.solr_name('available')]).first
  end

  def copyrighted
    Array(self[Solrizer.solr_name('copyrighted')]).first
  end

  def collected
    Array(self[Solrizer.solr_name('collected')]).first
  end

  def issued
    Array(self[Solrizer.solr_name('issued')]).first
  end

  def valid
    Array(self[Solrizer.solr_name('valid')]).first
  end

end
