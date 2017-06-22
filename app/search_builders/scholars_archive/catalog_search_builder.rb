class ScholarsArchive::CatalogSearchBuilder < Hyrax::CatalogSearchBuilder
  include BlacklightRangeLimit::RangeLimitBuilder
end