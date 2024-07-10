# frozen_string_literal:true

# OVERRIDE blacklight_oai_provider to remove Collections from list_records
BlacklightOaiProvider::SolrDocumentWrapper.class_eval do
  # conditions/query derived from options
  def conditions(options)
    query = @controller.search_builder.merge(sort: "#{solr_timestamp} asc", rows: limit).query

    # OVERRIDE: Remove collections
    # UPDATE: Make this query to use .map instead to modify and remove collection and check for nil
    query['fq'].map! { |f| f.sub(',Collection', '') if !f.blank? }
    # END OVERRIDE

    if options[:from].present? || options[:until].present?
      query.append_filter_query(
        "#{solr_timestamp}:[#{solr_date(options[:from])} TO #{solr_date(options[:until]).gsub('Z', '.999Z')}]"
      )
    end

    query.append_filter_query(@set.from_spec(options[:set])) if options[:set].present?
    query
  end
end
