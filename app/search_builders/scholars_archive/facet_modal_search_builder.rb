module ScholarsArchive
  class FacetModalSearchBuilder
    def admin_records(facet_string)
      clauses = [facet_search_string(facet_string), not_filesets].join(" AND ")
      "(#{clauses})"
    end

    def group_records(facet_string, group, visibility: nil)
      clauses = [facet_search_string(facet_string), read_access_group_string(group), visibility_string(visibility), not_filesets].join(" AND ")
      "(#{clauses})"
    end

    def edit_access_records(facet_string, username)
      clauses = [facet_search_string(facet_string), edit_access_string(username), not_filesets].join(" AND ")
      "(#{clauses})"
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

    def not_filesets
      "-has_model_ssim:FileSet"
    end
  end
end
