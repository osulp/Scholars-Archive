module ScholarsArchive
  module DefaultMetadata
    extend ActiveSupport::Concern

    # Usage notes and expectations can be found in the Metadata Application Profile:
    #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

    included do
      property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
        index.as :stored_searchable
      end

      property :academic_affiliation, predicate: ::RDF::URI("http://vivoweb.org/ontology/core#AcademicDepartment") do |index|
        index.as :stored_searchable, :facetable
      end

      property :additional_information, predicate: ::RDF::Vocab::DC.description do |index|
        index.as :stored_searchable
      end

      property :alt_title, predicate: ::RDF::Vocab::DC.alternative do |index|
        index.as :stored_searchable
      end

      property :based_near, predicate: ::RDF::Vocab::DC.spatial, class_name: Hyrax::ControlledVocabularies::Location do |index|
        index.as :stored_searchable, :facetable
      end

      property :bibliographic_citation, predicate: ::RDF::Vocab::DC.bibliographicCitation

      property :contributor, predicate: ::RDF::Vocab::DC11.contributor do |index|
        index.as :stored_searchable
      end

      property :creator, predicate: ::RDF::Vocab::DC11.creator do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_accepted, predicate: ::RDF::Vocab::DC.dateAccepted, multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_available, predicate: ::RDF::Vocab::DC.available, multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_collected, predicate: ::RDF::Vocab::DWC.measurementDeterminedDate do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_copyright, predicate: ::RDF::Vocab::DC.dateCopyrighted, multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_created, predicate: ::RDF::Vocab::DC.created, multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_issued, predicate: ::RDF::Vocab::DC.issued, multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :date_valid, predicate: ::RDF::Vocab::DC.valid, multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :description, predicate: ::RDF::Vocab::DC11.description do |index|
        index.as :stored_searchable
      end

      property :digitization_spec, predicate: ::RDF::URI.new("http://opaquenamespace.org/ns/conversionSpecifications") do |index|
        index.as :stored_searchable
      end

      property :doi, predicate: ::RDF::Vocab::Identifiers.doi, multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :dspace_collection, predicate: ::RDF::URI.new("http://opaquenamespace.org/ns/dspaceCollection") do |index|
      end

      property :dspace_community, predicate: ::RDF::URI.new("http://opaquenamespace.org/ns/dspaceCommunity") do |index|
      end

      property :embargo_reason, predicate: ::RDF::Vocab::DC.accessRights, multiple: false do |index|
        index.as :stored_searchable
      end

      property :file_extent, predicate: ::RDF::Vocab::DC.extent do |index|
        index.as :stored_searchable
      end

      property :file_format, predicate: ::RDF::Vocab::DC.FileFormat do |index|
        index.as :stored_searchable, :facetable
      end

      property :funding_body, predicate: ::RDF::Vocab::MARCRelators.fnd do |index|
        index.as :stored_searchable, :facetable
      end

      property :funding_statement, predicate: ::RDF::URI.new("http://datacite.org/schema/kernel-4/fundingReference") do |index|
        index.as :stored_searchable, :facetable
      end

      property :hydrologic_unit_code, predicate: ::RDF::URI.new("http://opaquenamespace.org/ns/hydrologicUnitCode") do |index|
        index.as :stored_searchable, :facetable
      end

      property :identifier, predicate: ::RDF::Vocab::DC.identifier do |index|
        index.as :stored_searchable
      end

      property :identifier_uri, predicate: ::RDF::Vocab::Identifiers.uri do |index|
        index.as :stored_searchable
      end

      property :import_url, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#importUrl'), multiple: false do |index|
        index.as :stored_searchable
      end

      property :in_series, predicate: ::RDF::URI.new("http://lsdis.cs.uga.edu/projects/semdis/opus#in_series") do |index|
        index.as :stored_searchable
      end

      property :isbn, predicate: ::RDF::Vocab::Identifiers.isbn do |index|
        index.as :stored_searchable
      end

      property :issn, predicate: ::RDF::Vocab::Identifiers.issn do |index|
        index.as :stored_searchable
      end

      property :keyword, predicate: ::RDF::Vocab::DC11.subject do |index|
        index.as :stored_searchable
      end

      property :label, predicate: ActiveFedora::RDF::Fcrepo::Model.downloadFilename, multiple: false do |index|
        index.as :stored_searchable
      end

      property :language, predicate: ::RDF::Vocab::DC11.language do |index|
        index.as :stored_searchable, :facetable
      end

      property :license, predicate: ::RDF::Vocab::DC.rights do |index|
        index.as :stored_searchable, :facetable
      end

      property :other_affiliation, predicate: ::RDF::URI("http://vivoweb.org/ontology/core#Department") do |index|
        index.as :stored_searchable, :facetable
      end

      property :part_of, predicate: ::RDF::Vocab::DC.isPartOf do |index|
        index.as :stored_searchable
      end

      property :peerreviewed, predicate: ::RDF::URI("http://purl.org/ontology/bibo/peerReviewed"), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :publisher, predicate: ::RDF::Vocab::DC11.publisher do |index|
        index.as :stored_searchable
      end

      property :nested_related_items, predicate: ::RDF::Vocab::DC.relation, :class_name => NestedRelatedItems do |index|
        index.as :stored_searchable
      end

      property :relative_path, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#relativePath'), multiple: false do |index|
        index.as :stored_searchable
      end

      property :replaces, predicate: ::RDF::Vocab::DC.replaces, multiple: false do |index|
        index.as :stored_searchable
      end

      property :resource_type, predicate: ::RDF::Vocab::DC.type do |index|
        index.as :stored_searchable, :facetable
      end

      property :rights_statement, predicate: ::RDF::Vocab::EDM.rights do |index|
        index.as :stored_searchable, :facetable
      end

      property :source, predicate: ::RDF::Vocab::DC.source do |index|
        index.as :stored_searchable
      end

      property :subject, predicate: ::RDF::Vocab::DC.subject do |index|
        index.as :stored_searchable, :facetable
      end

      property :tableofcontents, predicate: ::RDF::Vocab::DC.tableOfContents do |index|
        index.as :stored_searchable
      end

      property :nested_geo, :predicate => ::RDF::URI("https://purl.org/geojson/vocab#Feature"), :class_name => NestedGeo

      class_attribute :controlled_properties
      self.controlled_properties = [:based_near]

      accepts_nested_attributes_for :based_near, :allow_destroy => true, :reject_if => proc { |a| a[:id].blank? }
      accepts_nested_attributes_for :nested_geo, :allow_destroy => true, :reject_if => :all_blank
      accepts_nested_attributes_for :nested_related_items, :allow_destroy => true, :reject_if => :all_blank
    end
  end
end
