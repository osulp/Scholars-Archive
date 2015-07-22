class ScholarsArchiveSchema < ActiveTriples::Schema
  def self.property(name, options)
    super(name, options.merge(:class_name => TriplePoweredResource))
  end 

  property :resource_type, predicate: ::RDF::DC.type 
  property :tag, predicate: ::RDF::DC.relation
  property :spatial, predicate: ::RDF::DC.spatial
  property :contributor, predicate: ::RDF::DC.contributor
  property :temporal, predicate: ::RDF::DC.temporal
  property :creator, predicate: ::RDF::DC.creator
  property :abstract, predicate: ::RDF::DC.abstract
  property :tableOfContents, predicate: ::RDF::DC.tableOfContents
  property :description, predicate: ::RDF::DC.description
  property :format, predicate: ::RDF::DC.format
  property :bibliographicCitation, predicate: ::RDF::DC.bibliographicCitation
  property :language, predicate: ::RDF::DC.language
  property :publisher, predicate: ::RDF::DC.publisher
  property :provenance, predicate: ::RDF::DC.provenance
  property :isReferencedBy, predicate: ::RDF::DC.isReferencedBy
  property :relation, predicate: ::RDF::DC.relation
  property :rights, predicate: ::RDF::DC.rights
  property :subject, predicate: ::RDF::DC.subject
  property :title, predicate: ::RDF::DC.title
  property :dc_type, predicate: ::RDF::DC.type
  property :date, predicate: ::RDF::DC.date
  property :isCitedBy, predicate: ::RDF::URI("http://purl.org/spar/cito/isCitedBy")
  property :isIdenticalTo, predicate: ::RDF::URI("http://purl.org/dc/terms/isIdenticalto")
  property :isPartOf, predicate: ::RDF::DC.isPartOf
  property :isVersionOf, predicate: ::RDF::DC.isVersionOf
  property :doi, predicate: ::RDF::Vocab::Identifiers.doi
  property :hdl, predicate: ::RDF::Vocab::Identifiers.hdl
  property :orcid, predicate: ::RDF::Vocab::Identifiers.orcid
  property :rid, predicate: ::RDF::Vocab::Identifiers.rid
 

  def self.sufia_default
    [
      :resource_type,
      :title, 
      :creator, 
      :contributor, 
      :description, 
      :tag, 
      :rights,
      :publisher, 
      :date_created, 
      :subject, 
      :language, 
      :identifier, 
      :based_near, 
      :related_url
    ]
  end

  def self.presenter_properties
    properties.map(&:name).delete_if { |x| sufia_default.include?(x) }
  end

end
