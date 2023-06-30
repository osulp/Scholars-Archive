# frozen_string_literal: true

# nested ordered related items object
class NestedRelatedItems < ActiveTriples::Resource
  # Usage notes and expectations can be found in the Metadata Application Profile:
  #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

  property :label, predicate: ::RDF::Vocab::DC.title
  property :related_url, predicate: ::RDF::RDFS.seeAlso
  property :index, predicate: ::RDF::URI('http://purl.org/ontology/olo/core#index')

  attr_accessor :destroy_item # true/false
  attr_accessor :validation_msg # string

  def initialize(uri = RDF::Node.new, parent = nil)
    if uri.try(:node?)
      uri = RDF::URI("#nested_related_items#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?('#')
      uri = RDF::URI(uri)
    end
    super
  end

  def final_parent
    parent
  end

  def new_record?
    id.start_with?('#')
  end

  def _destroy
    false
  end
end
