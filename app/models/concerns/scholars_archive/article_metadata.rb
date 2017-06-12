module ScholarsArchive
  module ArticleMetadata
    extend ActiveSupport::Concern

    included do
      #reusable metadata fields for DSpace migration
     property :conference_location, predicate: ::RDF::URI.new("http://d-nb.info/standards/elementset/gnd#placeOfConferenceOrEvent") do |index|
        index.as :stored_searchable
      end

      property :conference_name, predicate: ::RDF::URI.new("http://purl.org/ontology/bibo/presentedAt") do |index|
        index.as :stored_searchable, :facetable
      end

      property :conference_section, predicate: ::RDF::URI.new("https://w3id.org/scholarlydata/ontology/conference-ontology.owl#Track") do |index|
        index.as :stored_searchable, :facetable
      end

      property :editor, predicate: ::RDF::URI.new("http://purl.org/ontology/bibo/editor") do |index|
        index.as :stored_searchable
      end

      property :has_journal, predicate: ::RDF::URI.new("http://purl.org/net/nknouf/ns/bibtex#hasJournal"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :has_number, predicate: ::RDF::URI.new("http://purl.org/net/nknouf/ns/bibtex#hasNumber"), multiple: false do |index|
        index.as :stored_searchable
      end

      property :has_volume, predicate: ::RDF::URI.new("http://purl.org/net/nknouf/ns/bibtex#hasVolume"), multiple: false do |index|
        index.as :stored_searchable
      end

      property :isbn, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/identifiers/isbn") do |index|
        index.as :stored_searchable
      end

      property :is_referenced_by, predicate: ::RDF::URI.new("http://purl.org/dc/terms/isReferencedBy") do |index|
        index.as :stored_searchable
      end
    end
  end
end
