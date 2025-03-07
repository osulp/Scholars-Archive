# frozen_string_literal: true

require 'rsolr'

module ScholarsArchive
  # Grabs all facet values
  class AllFacetValuesService
    ##
    # Query all values for a facet making use of the CatalogSearchBuilder to apply the
    # query parameters in the context of the current_user.
    #
    # @param facet [Blacklight::Configuration::FacetField] the facet to query all values for
    # @param controller [CatalogController] the catalog controller with blacklight_config and current_ability
    # @returns Array[string] an array of all of the facet values for the FacetField
    def call(facet, controller)
      params = catalog_search_params(controller)
      facets = solr_facets(facet.key, params)
      facets.keys
    end

    ##
    # Query SOLR and return a hash the facet value and hits
    #
    # @param facet_field [String] the field name for the facet query
    # @param params [Hash] the search parameters to apply to the facet query
    # @returns [Hash] a hash of the facet values and hit count
    def solr_facets(facet_field, params)
      solr_connection = RSolr.connect(url: ActiveFedora.solr_config[:url])
      response = solr_connection.get 'select', params: facet_params(facet_field, params)
      build_facet_hashes(response['facet_counts']['facet_fields'][facet_field])
    end

    ##
    # Build a hash in the form {"Author A" => 1, "Author B" => 2}
    # @param all_facets [Array] in the form ["Author A", 1, "Author B", 2]
    # @returns [Hash] in the form {"Author A" => 1, "Author B" => 2}
    def build_facet_hashes(all_facets)
      hashes = all_facets.each_slice(slice_count(all_facets.count)).map { |a| Hash[*a] }
      hashes.inject(&:merge)
    end

    ##
    # Calculate proper slice count
    # @param all_facets_count [Int] the total facets count
    # @returns [Int] an integer value that represents a total number of facet
    # groups
    def slice_count(all_facets_count)
      sub_facets_count = all_facets_count / 2
      sub_facets_count.odd? ? sub_facets_count - 1 : sub_facets_count
    end

    ##
    # Get a hash of the search parameters that would be used by the catalog controller
    #
    # @param controller [CatalogController] the catalog controller with blacklight_config and current_ability
    # @returns [Hash] a hash of the query parameters
    def catalog_search_params(controller)
      ScholarsArchive::CatalogSearchBuilder.new(controller).processed_parameters
    end

    private

    def facet_params(facet_field, params)
      params[:rows] = 0
      params[:facet] = 'on'
      params['facet.field'] = facet_field
      params['facet.limit'] = 100_000
      params["f.#{facet_field}.facet.limit"] = 100_000
      params
    end
  end
end
