# frozen_string_literal: true

# Copied from blacklight_advanced_search plugin, changed to remove filter adjustments
#
# Need to sub-class CatalogController so we get all other plugins behavior
# for our own "inside a search context" lookup of facets.
class BlacklightAdvancedSearch::AdvancedController < CatalogController
  # Enforces the bot detection for the advanced controller unless it's an oai request
  before_action except: :oai do |controller|
    BotDetectionController.bot_detection_enforce_filter(controller) unless valid_bot?
  end

  # 'ir.library.oregonstate.edu,ir-staging.library.oregonstate.edu,test.lib.oregonstate.edu:3000'
  def valid_bot?
    ENV.fetch('URI_TURNSTILE_BYPASS', '').split(',').include?(request.domain) || allow_listed_ip_addr?
  end

  def allow_listed_ip_addr?
    ips = ENV.fetch('IP_TURNSTILE_BYPASS', '') # '127.0.0.1-127.255.255.255,66.249.64.0-66.249.79.255'
    ranges = ips.split(',')
    ranges.each do |range|
      range = range.split('-')
      range = (IPAddr.new(range[0]).to_i..IPAddr.new(range[1]).to_i)
      return true if range.include?(IPAddr.new(request.remote_ip).to_i)
    end
    false
  end
  # Allow upstream caching of pages
  before_action :allow_page_caching

  def index
    @response = get_advanced_search_facets unless request.method == :post
  end

  protected

  # Override to use the engine routes
  def search_action_url(options = {})
    blacklight_advanced_search_engine.url_for(options.merge(action: 'index'))
  end

  def get_advanced_search_facets
    # We want to find the facets available for the current search, but:
    # * IGNORING current query (add in facets_for_advanced_search_form filter)
    # * IGNORING current advanced search facets (remove add_advanced_search_to_solr filter)
    blacklight_config.facet_fields.each do |_k, v|
      v.delete(:limit)
    end

    response, = search_results(params) do |search_builder|
      search_builder.except(:add_advanced_search_to_solr).append(:facets_for_advanced_search_form)
    end

    response
  end
end
