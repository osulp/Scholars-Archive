module ActiveArchive
  class Creator < ActiveArchive::OrderedNestable
    property :index, predicate: ::RDF::Vocab::DC.identifier
    property :creator, predicate: ::RDF::Vocab::DC.creator

    def initialize(uri=RDF::Node.new, parent=nil)
      if uri.try(:node?)
        uri = RDF::URI("#nested_ordered_creator#{uri.to_s.gsub('_:', '')}")
      elsif uri.start_with?("#")
        uri = RDF::URI(uri)
      end
      super
    end
  end
end
