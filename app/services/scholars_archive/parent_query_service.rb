# frozen_string_literal: true

module ScholarsArchive
  class ParentQueryService
    def self.query_parents_for_id(child_id)
      ActiveFedora::SolrService.get("member_ids_ssim:#{child_id}", rows: 100_000)['response']['docs']
    end
  end
end
