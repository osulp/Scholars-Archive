# -*- encoding : utf-8 -*-
class SolrDocument

  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Sufia behaviors to the SolrDocument.
  include Sufia::SolrDocumentBehavior


  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension( Blacklight::Document::Email )

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension( Blacklight::Document::Sms )

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension( Blacklight::Document::DublinCore)

  def nested_authors
    self.[]("nested_authors_label_ssim") || []
  end

  def nested_geo_points
    self.[]("nested_geo_points_label_ssim") || []
  end

  def nested_geo_bbox
    self.[]("nested_geo_bbox_label_ssim") || []
  end

  def nested_geo_location
    self.[]("nested_geo_location_name_ssim") || []
  end
  def tag_list
    self.to_model.tag.to_a || []
  end

end
