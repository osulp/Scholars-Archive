class ScholarsArchiveSchema < ActiveTriples::Schema

  property :keyword, predicate: ::RDF::DC11.subject
  property :spatial, predicate: ::RDF::DC.spatial
  property :provenance, predicate: ::RDF::DC.provenance
  property :date, predicate: ::RDF::DC.date
  property :doi, predicate: ::RDF::Vocab::Identifiers.doi
  property :orcid, predicate: ::RDF::Vocab::Identifiers.orcid
  property :rid, predicate: ::RDF::Vocab::Identifiers.rid
  property :accepted, predicate: ::RDF::DC.dateAccepted
  property :available, predicate: ::RDF::DC.available
  property :copyrighted, predicate: ::RDF::DC.dateCopyrighted
  # property :collected, predicate: ::RDF::DC.
  property :issued, predicate: ::RDF::DC.issued
  property :valid_date, predicate: ::RDF::DC.valid

end
