module ActiveArchive
  class Title < ActiveArchive::OrderedNestable
    property :index, predicate: ::RDF::Vocab::DC.identifier
    property :title, predicate: ::RDF::Vocab::DC.title
  end
end