# frozen_string_literal: true

# nested ordered creator object
class NestedOrderedCreator < NestedOrderedResource
  # Usage notes and expectations can be found in the Metadata Application Profile:
  #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

  property :index, predicate: ::RDF::URI('http://purl.org/ontology/olo/core#index')
  property :creator, predicate: ::RDF::Vocab::DC.creator

  def initialize(uri=RDF::Node.new, parent=nil)
    if uri.try(:node?)
      uri = RDF::URI("#nested_ordered_creator#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?('#')
      uri = RDF::URI(uri)
    end
    super
  end
end
