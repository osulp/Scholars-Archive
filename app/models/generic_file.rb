# app/models/generic_file.rb
class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  def self.property(prop_hash, options = {})
    prop_hash.each_pair do |prop, predicate|
      super(prop, build_options(options, predicate)) do |index|
        index.as :stored_searchable, :symbol
      end
    end
  end

  def self.build_options(options, predicate)
    return options.merge(:predicate => predicate, :class_name => TriplePoweredResource)
  end

  def self.property_list
    {
      :spatial => ::RDF::DC.spatial,
      :contributor => ::RDF::DC.contributor,
      :temporal => ::RDF::DC.temporal,
      :creator => ::RDF::DC.creator ,
      :abstract => ::RDF::DC.abstract,
      :tableOfContents => ::RDF::DC.tableOfContents,
      :description => ::RDF::DC.description,
      :format => ::RDF::DC.format,
      :bibliographicCitation => ::RDF::DC.bibliographicCitation,
      :language => ::RDF::DC.language,
      :publisher => ::RDF::DC.publisher,
      :provenance => ::RDF::DC.provenance,
      :isReferencedBy => ::RDF::DC.isReferencedBy,
      :relation => ::RDF::DC.relation,
      :rights => ::RDF::DC.rights,
      :subject => ::RDF::DC.subject,
      :title => ::RDF::DC.title,
      :dc_type => ::RDF::DC.type,
      :date => ::RDF::DC.date,
      :isCitedBy => ::RDF::URI("http://purl.org/spar/cito/isCitedBy"),
      :isIdenticalTo => ::RDF::URI("http://purl.org/dc/terms/isIdenticalto"),
      :isPartOf => ::RDF::DC.isPartOf,
      :isVersionOf => ::RDF::DC.isVersionOf,
      :doi => ::RDF::Vocab::Identifiers.doi,
      :hdl => ::RDF::Vocab::Identifiers.hdl,
      :orcid => ::RDF::Vocab::Identifiers.orcid,
      :rid => ::RDF::Vocab::Identifiers.rid, 
    }
  end 

  property property_list

end
