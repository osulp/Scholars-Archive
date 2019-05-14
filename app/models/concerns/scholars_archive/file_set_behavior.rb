module ScholarsArchive
  module FileSetBehavior
    extend ActiveSupport::Concern
    include Hyrax::WithEvents
    include Hydra::Works::FileSetBehavior
    include Hydra::Works::VirusCheck
    include Hyrax::FileSet::Characterization
    include Hydra::WithDepositor
    include Hyrax::Serializers
    include Hyrax::Noid
    include Hyrax::FileSet::Derivatives
    include Hyrax::Permissions
    include ScholarsArchive::FileSet::Indexing
    include Hyrax::FileSet::BelongsToWorks
    include Hyrax::FileSet::Querying
    include Hyrax::HumanReadableType
    include Hyrax::CoreMetadata
    include Hyrax::BasicMetadata
    include Hyrax::Naming
    include Hydra::AccessControls::Embargoable
    include GlobalID::Identification

    included do
      attr_accessor :file
    end

    def representative_id
      to_param
    end

    def thumbnail_id
      to_param
    end

    # Cast to a SolrDocument by querying from Solr
    def to_presenter
      CatalogController.new.fetch(id).last
    end
  end
end