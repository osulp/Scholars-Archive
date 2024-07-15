# frozen_string_literal: true

# builds searches for search result page
class ScholarsArchive::CatalogSearchBuilder < Hyrax::CatalogSearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include BlacklightRangeLimit::RangeLimitBuilder
  include Hydra::AccessControlsEnforcement
  include Hyrax::SearchFilters
  self.default_processor_chain += %i[add_advanced_search_to_solr]
end
