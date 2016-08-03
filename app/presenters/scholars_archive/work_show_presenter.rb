module ScholarsArchive
  class WorkShowPresenter < ::Sufia::WorkShowPresenter
    # delegate fields from Sufia::Works::Metadata to solr_document
    delegate :based_near, :related_url, :depositor, :identifier, :resource_type, :accepted, :available, :copyrighted, :collected, :issued, :valid, :itemtype, :nested_geo_points, :nested_geo_bbox, :nested_geo_location, to: :solr_document

  end
end
