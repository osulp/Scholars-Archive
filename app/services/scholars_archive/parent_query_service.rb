# frozen_string_literal: true

module ScholarsArchive
  # Query for parent
  class ParentQueryService
    def self.query_parents_for_id(child_id)
      ActiveFedora::SolrService.get("member_ids_ssim:#{child_id}", :rows => 100000)['response']['docs']
    end
  end
end
