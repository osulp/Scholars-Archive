module ScholarsArchive
  class AllVisibleFacetsService
    def call(current_user, facet)
      facets('*:* AND -suppressed_bsi:true', facet.key)
    end

    private

    def facets(query_string, facet_field)
      solr_connection = RSolr::Ext.connect(url: ActiveFedora.solr_config[:url])
      params = {
        rows: 0,
        queries: query_string,
        facets: { fields: [facet_field] },
        "facet.limit" => 100000
      }
      response = solr_connection.find(params, method: :get)
      results = Hash[*response['facet_counts']['facet_fields'][facet_field]]
      results.keys
    end
  end
end
