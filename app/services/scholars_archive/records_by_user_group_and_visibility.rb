module ScholarsArchive
  class RecordsByUserGroupAndVisibility
    def call(current_user, facet)
      records = []
      #If user is admin, return all records under a specific facet search
      if current_user.admin?
        records << admin_search(facet)
      #If user is a guest, only show public works in the users groups
      elsif current_user.guest?
        current_user.groups.each do |group|
          records << public_search(facet, group)
        end
      #User is authenticated and should see both public and authenticated works
      else
        current_user.groups.each do |group|
          records << public_search(facet, group)
          records << authenticated_search(facet, group)
        end
      end
      records << other_owned_records(facet, current_user.username)
      records.flatten.uniq! { |hash| hash["id"] }
    end

    private

    def public_search(facet, group)
      search_builder.group_records(facet.key, group, visibility: "public")
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
