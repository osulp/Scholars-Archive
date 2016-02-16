class ScholarsArchiveSchema < ActiveTriples::Schema

  property :language, predicate: ::RDF::DC11.language
  property :publisher, predicate: ::RDF::DC11.publisher
  property :keyword, predicate: ::RDF::DC11.subject
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
  property :decimalLatitude, predicate: ::RDF::URI('http://rs.tdwg.org/dwc/terms/decimalLatitude')
  property :decimalLongitude, predicate: ::RDF::URI('http://rs.tdwg.org/dwc/terms/decimalLongitude')
  property :bbox, predicate: ::RDF::URI('http://opaquenamespace.org/ns/georss/box')

end
