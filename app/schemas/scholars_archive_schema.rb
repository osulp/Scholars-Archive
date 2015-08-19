class ScholarsArchiveSchema < ActiveTriples::Schema

  property :spatial, predicate: ::RDF::DC.spatial
  property :provenance, predicate: ::RDF::DC.provenance
  property :date, predicate: ::RDF::DC.date
  property :doi, predicate: ::RDF::Vocab::Identifiers.doi
  property :orcid, predicate: ::RDF::Vocab::Identifiers.orcid
  property :rid, predicate: ::RDF::Vocab::Identifiers.rid
 
end
