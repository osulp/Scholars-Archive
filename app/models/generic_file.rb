# app/models/generic_file.rb
class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  include Hydra::AccessControls::Embargoable

  def self.property(name, options)
    super(name, {:class_name => TriplePoweredResource}.merge(options)) do |index|
      index.as :stored_searchable, :symbol
    end
  end 

  apply_schema ScholarsArchiveSchema,
    ActiveFedora::SchemaIndexingStrategy.new(
      ActiveFedora::Indexers::GlobalIndexer.new([:stored_searchable, :symbol])
    )

  property :nested_authors, :predicate => ::RDF::URI("http://id.loc.gov/vocabulary/relators/aut"), :class_name => NestedAuthor

  accepts_nested_attributes_for :nested_authors, :allow_destroy => true, :reject_if => :all_blank

  def to_solr(solr_doc = {})
    super.tap do |doc|
      doc[ActiveFedora::SolrQueryBuilder.solr_name("nested_authors_label", :symbol)] = nested_authors.flat_map(&:name).select(&:present?)
      doc[ActiveFedora::SolrQueryBuilder.solr_name("nested_authors_label", :stored_searchable)] = nested_authors.flat_map(&:name).select(&:present?)
    end
  end
end
