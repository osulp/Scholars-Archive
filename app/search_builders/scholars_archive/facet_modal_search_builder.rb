module ScholarsArchive
  class FacetModalSearchBuilder
    def admin_records(facet_string)
      solr_service.get(facet_search_string(facet_string), :rows => 1000000)["response"]["docs"]
    end

    def group_records(facet_string, group, visibility: nil)
      solr_service.get(facet_search_string(facet_string) + " AND " +
                       read_access_group_string(group) + " AND " +
                       visibility_string(visibility), :rows => 1000000)["response"]["docs"]
    end

    def edit_access_records(facet_string, username)
      solr_service.get(facet_search_string(facet_string) + " AND " + edit_access_string(username), :rows => 1000000)["response"]["docs"]
    end

    private

    def facet_search_string(facet_string)
      "#{facet_string}:*"
    end

    def read_access_group_string(group)
      "read_access_group_ssim:#{group}"
    end

    def visibility_string(visibility)
      "visibility_ssi:#{visibility}"
    end

    def edit_access_string(username)
      "edit_access_person_ssim:#{username}"
    end

    def solr_service
      ActiveFedora::SolrService
    end
  end
end
