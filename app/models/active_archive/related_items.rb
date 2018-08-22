module ActiveArchive
  class RelatedItems < ActiveArchive::OrderedNestable
    property :label, predicate: ::RDF::Vocab::DC.title
    property :related_url, predicate: ::RDF::RDFS.seeAlso
  end
end
