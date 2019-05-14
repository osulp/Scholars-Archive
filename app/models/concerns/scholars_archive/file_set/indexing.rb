module ScholarsArchive
  module FileSet
    module Indexing
      extend ActiveSupport::Concern

      included do
        # the default indexing service
        self.indexer = FileSetIndexer
      end
    end
  end
end
