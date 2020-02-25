# frozen_string_literal: true

# nested ordered additional information object
class NestedOrderedAdditionalInformation < NestedOrderedResource
  # Usage notes and expectations can be found in the Metadata Application Profile:
  #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

  property :index, predicate: ::RDF::URI('http://purl.org/ontology/olo/core#index')
  property :additional_information, predicate: ::RDF::Vocab::DC.description

  def initialize(uri=RDF::Node.new, parent=nil)
    if uri.try(:node?)
      uri = RDF::URI("#nested_ordered_additional_information#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?('#')
      uri = RDF::URI(uri)
    end
    super
  end
end
