class ScholarsArchiveSchema < ActiveTriples::Schema

  property :spatial, predicate: ::RDF::DC.spatial
  property :temporal, predicate: ::RDF::DC.temporal
  property :tableOfContents, predicate: ::RDF::DC.tableOfContents
  property :format, predicate: ::RDF::DC.format
  property :provenance, predicate: ::RDF::DC.provenance
  property :isReferencedBy, predicate: ::RDF::DC.isReferencedBy
  property :date, predicate: ::RDF::DC.date
  property :isCitedBy, predicate: ::RDF::URI("http://purl.org/spar/cito/isCitedBy")
  property :isIdenticalTo, predicate: ::RDF::URI("http://purl.org/dc/terms/isIdenticalto")
  property :isVersionOf, predicate: ::RDF::DC.isVersionOf
  property :doi, predicate: ::RDF::Vocab::Identifiers.doi
  property :hdl, predicate: ::RDF::Vocab::Identifiers.hdl
  property :orcid, predicate: ::RDF::Vocab::Identifiers.orcid
  property :rid, predicate: ::RDF::Vocab::Identifiers.rid
 
end
