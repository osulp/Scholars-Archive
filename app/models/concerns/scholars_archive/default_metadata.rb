module ScholarsArchive
  module DefaultMetadata
    extend ActiveSupport::Concern

    included do
      #reusable metadata fields for DSpace migration
      property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
        index.as :stored_searchable
      end

      property :additional_information, predicate: ::RDF::URI.new("http://purl.org/dc/terms/description") do |index|
        index.as :stored_searchable
      end

      property :alt_title, predicate: ::RDF::URI.new("http://purl.org/dc/terms/alternative") do |index|
        index.as :stored_searchable
      end

      #basicmetadata import from hyrax
      property :based_near, predicate: ::RDF::Vocab::FOAF.based_near do |index|
        index.as :stored_searchable
      end

      property :bibliographic_citation, predicate: ::RDF::Vocab::DC.bibliographicCitation do |index|
        index.as :stored_searchable
      end

      property :contributor, predicate: ::RDF::Vocab::DC11.contributor do |index|
          index.as :stored_searchable
      end

      property :creator, predicate: ::RDF::Vocab::DC11.creator do |index|
        index.as :stored_searchable
      end

      property :date_accepted, predicate: ::RDF::URI.new("http://purl.org/dc/terms/dateAccepted"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_available, predicate: ::RDF::URI.new("http://purl.org/dc/terms/available"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_collected, predicate: ::RDF::URI.new("http://rs.tdwg.org/dwc/terms/measurementDeterminedDate"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_copyright, predicate: ::RDF::URI.new("http://purl.org/dc/terms/dateCopyrighted"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_created, predicate: ::RDF::Vocab::DC.created, multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_issued, predicate: ::RDF::URI.new("http://purl.org/dc/terms/issued"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_valid, predicate: ::RDF::URI.new("http://purl.org/dc/terms/valid"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :description, predicate: ::RDF::Vocab::DC11.description do |index|
        index.as :stored_searchable
      end

      property :digitization_spec, predicate: ::RDF::URI.new("http://opaquenamespace.org/ns/conversionSpecifications") do |index|
        index.as :stored_searchable
      end

      property :doi, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/identifiers/doi") do |index|
        index.as :stored_searchable
      end

      property :dspace_collection, predicate: ::RDF::URI.new("http://opaquenamespace.org/ns/dspaceCollection") do |index|
      end

      property :dspace_community, predicate: ::RDF::URI.new("http://opaquenamespace.org/ns/dspaceCommunity") do |index|
      end

      property :file_extent, predicate: ::RDF::URI.new("http://purl.org/dc/terms/extent") do |index|
        index.as :stored_searchable
      end

      property :file_format, predicate: ::RDF::URI.new("http://purl.org/dc/terms/FileFormat") do |index|
        index.as :stored_searchable
      end

      property :funding_body, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/relators/fnd") do |index|
        index.as :stored_searchable
      end

      property :funding_statement, predicate: ::RDF::URI.new("http://datacite.org/schema/kernel-4/fundingReference") do |index|
        index.as :stored_searchable
      end

      property :hydrologic_unit_code, predicate: ::RDF::URI.new("http://opaquenamespace.org/ns/hydrologicUnitCode") do |index|
        index.as :stored_searchable
      end

      property :identifier, predicate: ::RDF::Vocab::DC.identifier do |index|
        index.as :stored_searchable
      end

      property :identifier_uri, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/identifiers/uri") do |index|
        index.as :stored_searchable
      end

      property :import_url, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#importUrl'), multiple: false do |index|
        index.as :stored_searchable
      end

      property :in_series, predicate: ::RDF::URI.new("http://lsdis.cs.uga.edu/projects/semdis/opus#in_series") do |index|
        index.as :stored_searchable
      end

      property :isbn, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/identifiers/isbn") do |index|
        index.as :stored_searchable
      end

      property :keyword, predicate: ::RDF::Vocab::DC11.relation do |index|
        index.as :stored_searchable
      end

      property :label, predicate: ActiveFedora::RDF::Fcrepo::Model.downloadFilename, multiple: false do |index|
        index.as :stored_searchable
      end

      property :language, predicate: ::RDF::Vocab::DC11.language do |index|
        index.as :stored_searchable
      end

      # Used for a license
      property :license, predicate: ::RDF::Vocab::DC.rights do |index|
        index.as :stored_searchable
      end

      property :part_of, predicate: ::RDF::Vocab::DC.isPartOf do |index|
        index.as :stored_searchable
      end

      property :peerreviewed, predicate: ::RDF::URI.new("http://purl.org/ontology/bibo/peerReviewed") do |index|
        index.as :stored_searchable
      end

      property :publisher, predicate: ::RDF::Vocab::DC11.publisher do |index|
        index.as :stored_searchable
      end

      property :relation, predicate: ::RDF::URI.new("http://purl.org/dc/terms/relation") do |index|
        index.as :stored_searchable
      end

      property :related_url, predicate: ::RDF::RDFS.seeAlso do |index|
        index.as :stored_searchable
      end

      property :relative_path, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#relativePath'), multiple: false do |index|
        index.as :stored_searchable
      end

      property :replaces, predicate: ::RDF::Vocab::DC.replaces do |index|
        index.as :stored_searchable
      end

      property :resource_type, predicate: ::RDF::Vocab::DC.type do |index|
        index.as :stored_searchable
      end

      property :rights_statement, predicate: ::RDF::Vocab::EDM.rights do |index|
        index.as :stored_searchable
      end

      property :source, predicate: ::RDF::Vocab::DC.source do |index|
        index.as :stored_searchable
      end

      property :subject, predicate: ::RDF::Vocab::DC11.subject do |index|
        index.as :stored_searchable
      end

      property :tableofcontents, predicate: ::RDF::URI.new("http://purl.org/dc/terms/tableOfContents") do |index|
        index.as :stored_searchable
      end

    end
  end
end
