module ScholarsArchive
  module DateMetadata
    included do
      property :accepted, :predicate => ::RDF::DC.dateAccepted do |index|
        index.as :stored_searchable, :facetable
      end
    end
  end
end
