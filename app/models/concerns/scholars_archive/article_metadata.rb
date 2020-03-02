# frozen_string_literal: true

module ScholarsArchive
  # article metadata
  module ArticleMetadata
    extend ActiveSupport::Concern

    # Usage notes and expectations can be found in the Metadata Application Profile:
    #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

    included do
      initial_properties = properties.keys
      property :editor, predicate: ::RDF::Vocab::BIBO.editor do |index|
        index.as :stored_searchable
      end

      property :has_journal, predicate: ::RDF::URI.new('http://purl.org/net/nknouf/ns/bibtex#hasJournal'), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :has_number, predicate: ::RDF::URI.new('http://purl.org/net/nknouf/ns/bibtex#hasNumber'), multiple: false do |index|
        index.as :stored_searchable
      end

      property :has_volume, predicate: ::RDF::URI.new('http://purl.org/net/nknouf/ns/bibtex#hasVolume'), multiple: false do |index|
        index.as :stored_searchable
      end

      property :is_referenced_by, predicate: ::RDF::Vocab::DC.isReferencedBy do |index|
        index.as :stored_searchable
      end

      property :web_of_science_uid, predicate: ::RDF::URI.new('http://opaquenamespace.org/ns/webOfScienceUid'), multiple: false do |index|
        index.as :stored_searchable
      end

      define_singleton_method :article_properties do
        (properties - initial_properties)
      end

      ARTICLE_PRIMARY_TERMS = %i[
        nested_ordered_title
        alt_title
        nested_ordered_creator
        nested_ordered_contributor
        nested_ordered_abstract
        license
        resource_type
        doi
        dates_section
        bibliographic_citation
        is_referenced_by
        has_journal
        has_volume
        has_number
        conference_name
        conference_section
        conference_location
        editor
        academic_affiliation
        other_affiliation
        in_series
        subject
        tableofcontents
        rights_statement
      ].freeze
    end
  end
end
