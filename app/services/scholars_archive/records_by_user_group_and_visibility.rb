module ScholarsArchive
  class RecordsByUserGroupAndVisibility
    #def call(current_user, facet)
    #  records = []
    #  if current_user.admin?
    #    records << admin_search(facet)
    #  elsif current_user.guest?
    #    current_user.groups.each do |group|
    #      records << public_search(facet, group)
    #    end
    #  else
    #    current_user.groups.each do |group|
    #      records << public_search(facet, group)
    #      records << authenticated_search(facet, group)
    #    end
    #  end
    #  records << other_owned_records(facet, current_user.username)
    #  records.flatten.uniq! { |hash| hash["id"] }
    #end

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
      puts facet.key
      puts ActiveFedora::SolrService.get( query_strings.join(" OR "), :rows => 1000000 )["response"]["docs"]
      ActiveFedora::SolrService.get( query_strings.join(" OR "), :rows => 1000000 )["response"]["docs"].map { |item| item[facet.key.gsub("sim", "tesim")] }.uniq
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
  end
end
