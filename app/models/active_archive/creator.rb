module ActiveArchive
  class Creator < ActiveArchive::OrderedNestable
    property :index, predicate: ::RDF::Vocab::DC.identifier
    property :creator, predicate: ::RDF::Vocab::DC.creator
  end
end
