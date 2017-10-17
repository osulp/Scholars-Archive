class ReindexEverythingJob < Hyrax::ApplicationJob
  queue_as :default

  def perform
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/sa-reindex-everything-jid-#{self.job_id}.log")
    admin_set_map = YAML.load(File.read("config/admin_set_map.yml"))
    logger.info "Reindex Everything"
    counter = 0

    admin_set_map.each do |model, desc|
      index = ActiveFedora::SolrService.get("has_model_ssim:#{model}", rows: 100000)["response"]["docs"]
      logger.info "Reindexing #{model} (#{desc}): #{index.count}"
      index.each do |work|
        logger.info "\t reindexing #{work["id"]}"
        begin
          ActiveFedora::Base.find(work["id"]).update_index
          counter += 1
        rescue => e
          logger.info "Failed to reindex #{work["id"]}: #{e.message}"
        end
      end
    end
    logger.info "Total indexed: #{counter}"
    logger.info "Done"
  end
end