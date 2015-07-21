# app/models/generic_file.rb
class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  def self.property(name, options)
    super(name, options.merge(:class_name => TriplePoweredResource))
  end
   
  property :spatial, predicate: ::RDF::DC.spatial do |index|
    index.as :stored_searchable, :symbol
  end		
  property :contributor, predicate: ::RDF::DC.contributor do |index|		
    index.as :stored_searchable, :symbol
  end		
  property :temporal, predicate: ::RDF::DC.temporal do |index|		
    index.as :stored_searchable, :symbol
  end		
  property :creator, predicate: ::RDF::DC.creator do |index|		
    index.as :stored_searchable, :symbol
  end		
  property :abstract, predicate: ::RDF::DC.abstract do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :tableOfContents, predicate: ::RDF::DC.tableOfContents do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :description, predicate: ::RDF::DC.description do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :format, predicate: ::RDF::DC.format do |index|		
    index.as :stored_searchable, :symbol
  end		
  property :bibliographicCitation, predicate: ::RDF::DC.bibliographicCitation do |index|		
    index.as :stored_searchable, :symbol
  end		
  property :language, predicate: ::RDF::DC.language do |index|		
    index.as :stored_searchable, :symbol
  end		
  property :publisher, predicate: ::RDF::DC.publisher do |index|		
    index.as :stored_searchable, :symbol
  end		
  property :provenance, predicate: ::RDF::DC.provenance do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :isReferencedBy, predicate: ::RDF::DC.isReferencedBy do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :relation, predicate: ::RDF::DC.relation do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :rights, predicate: ::RDF::DC.rights do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :subject, predicate: ::RDF::DC.subject do |index|		
    index.as :stored_searchable, :symbol
  end		
  property :title, predicate: ::RDF::DC.title do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :dc_type, predicate: ::RDF::DC.type do |index|		
    index.as :stored_searchable, :symbol
  end		
  property :date, predicate: ::RDF::DC.date do |index|		
    index.as :stored_searchable, :symbol	
  end		
  property :isCitedBy, predicate: ::RDF::URI("http://purl.org/spar/cito/isCitedBy") do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :isIdenticalTo, predicate: ::RDF::URI("http://purl.org/dc/terms/isIdenticalto") do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :isPartOf, predicate: ::RDF::DC.isPartOf do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :isVersionOf, predicate: ::RDF::DC.isVersionOf do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :doi, predicate: ::RDF::Vocab::Identifiers.doi do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :hdl, predicate: ::RDF::Vocab::Identifiers.hdl do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :orcid, predicate: ::RDF::Vocab::Identifiers.orcid do |index|		
    index.as :stored_searchable, :symbol		
  end		
  property :rid, predicate: ::RDF::Vocab::Identifiers.rid do |index|		
    index.as :store_searchable, :symbol
  end 
end
