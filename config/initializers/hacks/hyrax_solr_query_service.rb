# frozen_string_literal: true

Rails.application.config.to_prepare do
  Hyrax::SolrQueryService.class_eval do
    ##
    # execute the solr query and return results
    # @return [Hash] the results returned from solr for the current query
    def query_result
      # increase minimum query rows (increase review queue size)
      solr_service.query_result(build, rows: 1_000)
    end

    ##
    # Restore the 3.6.0 args that 4.0.0 dropped.
    # Backport of https://github.com/samvera/hyrax/pull/6000. Remove this overriden file when/if upgrading to Hyrax 5.x
    def solr_documents(page: 1, rows: nil, sort: nil)
      params = {}
      if rows
        params[:rows] = rows
        params[:start] = (page.to_i - 1) * rows.to_i
      end
      params[:sort] = sort if sort

      # query_result is the v4, no-args path.
      # solr_service.query_result is the v3/v5 backport, w/ args path.
      raw = params.empty? ? query_result : solr_service.query_result(build, **params)

      raw['response']['docs'].map { |doc| self.class.document_model.new(doc) }
    end
  end
end
