# frozen_string_literal: true

# reindexes everything
class ReindexEverythingJob < ScholarsArchive::ApplicationJob
  queue_as :reindex

  def perform
    admin_set_map = YAML.safe_load(File.read('config/admin_set_map.yml'))
    Rails.logger.info 'Reindex Everything'
    counter = 0

    admin_set_map.each do |model, desc|
      index = ActiveFedora::SolrService.get("has_model_ssim:#{model}", rows: 100_000)['response']['docs']
      Rails.logger.info "Reindexing #{model} (#{desc}): #{index.count}"
      index.each do |work|
        Rails.logger.info "\t reindexing #{work['id']}"
        begin
          ActiveFedora::Base.find(work['id']).update_index
          counter += 1
        rescue StandardError => e
          Rails.logger.info "Failed to reindex #{work['id']}: #{e.message}"
        end
      end
    end
    Rails.logger.info "Total indexed: #{counter}"
    Rails.logger.info 'Done'
  end
end
