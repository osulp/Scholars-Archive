class ScholarsArchiveSchema < ActiveTriples::Schema
  property :tag, predicate: ::RDF::DC11.subject
  property :language, predicate: ::RDF::DC11.language
  property :spatial, predicate: ::RDF::DC.spatial
  property :provenance, predicate: ::RDF::DC.provenance
  property :date, predicate: ::RDF::DC.date
  property :doi, predicate: ::RDF::Vocab::Identifiers.doi
  property :accepted, predicate: ::RDF::DC.dateAccepted
  property :available, predicate: ::RDF::DC.available
  property :copyrighted, predicate: ::RDF::DC.dateCopyrighted
  property :collected, predicate: ::RDF::URI('http://rs.tdwg.org/dwc/terms/measurementDeterminedBy')
  property :issued, predicate: ::RDF::DC.issued
  property :valid_date, predicate: ::RDF::DC.valid

end
