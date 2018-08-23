module ActiveArchive
  class RelatedItems < ActiveArchive::OrderedNestable
    property :label, predicate: ::RDF::Vocab::DC.title
    property :related_url, predicate: ::RDF::RDFS.seeAlso
    property :index, predicate: ::RDF::Vocab::DC.identifier

    def initialize(uri=RDF::Node.new, parent=nil)
      if uri.try(:node?)
        uri = RDF::URI("#nested_related_items#{uri.to_s.gsub('_:', '')}")
      elsif uri.start_with?("#")
        uri = RDF::URI(uri)
      end
      super
    end
  end
end
