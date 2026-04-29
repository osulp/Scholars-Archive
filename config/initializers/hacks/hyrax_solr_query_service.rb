# frozen_string_literal:true

Rails.application.config.to_prepare do
  Hyrax::SolrQueryService.class_eval do
    ##
    # execute the solr query and return results
    # @return [Hash] the results returned from solr for the current query
    def query_result
      # increase minimum query rows (increase review queue size)
      solr_service.query_result(build, rows: 1000)
    end
  end
end
