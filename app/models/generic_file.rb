# app/models/generic_file.rb
class GenericFile < ActiveFedora::Base
  def self.property(name, options)
    super(name, options.merge(:class_name => TriplePoweredResource))
  end 
  include Sufia::GenericFile
  apply_schema ScholarsArchiveSchema,
    ActiveFedora::SchemaIndexingStrategy.new(
      ActiveFedora::Indexers::GlobalIndexer.new([:stored_searchable, :symbol])
    )

end
