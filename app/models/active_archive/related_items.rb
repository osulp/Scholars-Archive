module ActiveArchive
  class RelatedItems < ActiveArchive::OrderedNestable
    property :label, predicate: ::RDF::Vocab::DC.title
    property :related_url, predicate: ::RDF::RDFS.seeAlso
    property :index, predicate: ::RDF::Vocab::DC.identifier
  end
end
