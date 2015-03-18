# app/models/generic_file.rb
class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile

  property :spatial, predicate: ::RDF::DC.spatial do |index|
    index.as :stored_searchable, :facetable
  end

  property :doi, predicate: ::RDF::Vocab::Identifiers.doi do |index|
    index.as :stored_searchable, :facetable
  end
end
