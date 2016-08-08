module ScholarsArchive
  class WorkShowPresenter < WorkShowPresenter
    # delegate fields from Sufia::Works::Metadata to solr_document
    delegate :accepted, :available, :copyrighted, :collected, :issued, :valid, :nested_geo_points, :nested_geo_bbox, :nested_geo_location, to: :solr_document

  end
end
