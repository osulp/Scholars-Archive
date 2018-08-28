module ActiveArchive
  class Title < ActiveArchive::OrderedNestable
    property :index, predicate: ::RDF::Vocab::DC.identifier
    property :title, predicate: ::RDF::Vocab::DC.title

    def initialize(uri=RDF::Node.new, parent=nil)
      if uri.try(:node?)
        uri = RDF::URI("#nested_ordered_title#{uri.to_s.gsub('_:', '')}")
      elsif uri.start_with?("#")
        uri = RDF::URI(uri)
      end
      super
    end
  end
end