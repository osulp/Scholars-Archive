# frozen_string_literal: true

# search builder object
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  self.default_processor_chain += %i[add_advanced_search_to_solr]
  include BlacklightRangeLimit::RangeLimitBuilder

  include Hydra::AccessControlsEnforcement
  include Hyrax::SearchFilters

  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end
end
