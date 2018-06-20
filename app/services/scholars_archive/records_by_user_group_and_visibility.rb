module ScholarsArchive
  class RecordsByUserGroupAndVisibility
    def call(current_user, facet)
      query_strings = []
      if current_user.admin?
        query_strings << admin_search(facet)
      elsif current_user.guest?
        current_user.groups.each do |group|
          query_strings << public_search(facet, group)
        end
      else
        current_user.groups.each do |group|
          query_strings << public_search(facet, group)
          query_strings << authenticated_search(facet, group)
        end
      end
      query_strings << other_owned_records(facet, current_user.username)
      facets(query_strings, facet.key)
    end

    private

    def public_search(facet, group)
      search_builder.group_records(facet.key, group, visibility: "open")
    end

    def authenticated_search(facet, group)
      search_builder.group_records(facet.key, group, visibility: "authenticated")
    end

    def admin_search(facet)
      search_builder.admin_records(facet.key)
    end

    def other_owned_records(facet, username)
      search_builder.edit_access_records(facet.key, username)
    end

    def search_builder
      ScholarsArchive::FacetModalSearchBuilder.new
    end

    def solr_connection
      RSolr::Ext.connect(url: ActiveFedora.solr_config[:url])
    end

    def solr_params(query_strings, facet_field)
      {
        rows: 0,
        queries: query_strings,
        facets: { fields: [facet_field], limit: 10000 }
      }
    end

    def facets(query_strings, facet_field)
      response = solr_connection.find(solr_params(query_strings, facet_field), method: :get)
      Hash[*response['facet_counts']['facet_fields'][facet_field]].keys
    end
  end
end
