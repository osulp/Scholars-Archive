module ScholarsArchive
  module ArticleMetadata
    extend ActiveSupport::Concern

    # Usage notes and expectations can be found in the Metadata Application Profile:
    #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

    included do
      # multiple: false, until "conference" is converted to a nested attribute so that the location, name, and section are all related/stored together
      property :conference_location, predicate: ::RDF::URI.new("http://d-nb.info/standards/elementset/gnd#placeOfConferenceOrEvent"), multiple: false do |index|
        index.as :stored_searchable
      end

      # multiple: false, until "conference" is converted to a nested attribute so that the location, name, and section are all related/stored together
      property :conference_name, predicate: ::RDF::Vocab::BIBO.presentedAt, multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      # multiple: false, until "conference" is converted to a nested attribute so that the location, name, and section are all related/stored together
      property :conference_section, predicate: ::RDF::URI.new("https://w3id.org/scholarlydata/ontology/conference-ontology.owl#Track"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :editor, predicate: ::RDF::Vocab::BIBO.editor do |index|
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

      property :is_referenced_by, predicate: ::RDF::Vocab::DC.isReferencedBy do |index|
        index.as :stored_searchable
      end
    end
  end
end
