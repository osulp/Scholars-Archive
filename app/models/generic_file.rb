# app/models/generic_file.rb
class GenericFile < ActiveFedora::Base
  def self.property(name, options)
    super(name, {:class_name => TriplePoweredResource}.merge(options)) do |index|
      index.as :stored_searchable, :symbol
    end
  end 
  include Sufia::GenericFile
  apply_schema ScholarsArchiveSchema,
    ActiveFedora::SchemaIndexingStrategy.new(
      ActiveFedora::Indexers::GlobalIndexer.new([:stored_searchable, :symbol])
    )
  property :nested_authors, :predicate => ::RDF::URI("http://id.loc.gov/vocabulary/relators/aut"), :class_name => NestedAuthor
  accepts_nested_attributes_for :nested_authors, :allow_destroy => true, :reject_if => :all_blank
end
