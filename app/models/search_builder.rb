# frozen_string_literal: true

# search builder object
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  self.default_processor_chain += %i[add_advanced_parse_q_to_solr add_advanced_search_to_solr]
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

  def add_advanced_parse_q_to_solr(solr_parameters)
    default_field_def = {advanced_parse: false}

    return if blacklight_params[:q].blank? || !blacklight_params[:q].respond_to?(:to_str)

    field_def = blacklight_config.search_fields[blacklight_params[:search_field]] ||
      blacklight_config.default_search_field

    field_def = default_field_def if field_def.nil?

    # If the individual field has advanced_parse_q suppressed, punt
    return if field_def[:advanced_parse] == false

    solr_direct_params = field_def[:solr_parameters] || {}
    solr_local_params = field_def[:solr_local_parameters] || {}

    # See if we can parse it, if we can't, we're going to give up
    # and just allow basic search, perhaps with a warning.
    begin
      adv_search_params = ParsingNesting::Tree.parse(blacklight_params[:q], blacklight_config.advanced_search[:query_parser]).to_single_query_params(solr_local_params)

      BlacklightAdvancedSearch.deep_merge!(solr_parameters, solr_direct_params)
      BlacklightAdvancedSearch.deep_merge!(solr_parameters, adv_search_params)
    rescue *PARSLET_FAILED_EXCEPTIONS => e
      # do nothing, don't merge our input in, keep basic search
      # optional TODO, display error message in flash here, but hard to
      # display a good one.
      return
    end
  end
end
