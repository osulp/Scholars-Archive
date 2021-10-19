# frozen_string_literal: true

# reindexes all works of a single model
class ReindexModelJob < ScholarsArchive::ApplicationJob
  queue_as :default

  def perform(model_name, uris)
    # Make sure logging directory exists and get our logger
    file_name = "#{Rails.root}/log/sa-reindex/jid-#{job_id}-#{model_name}.log"
    dir_name = File.dirname(file_name)
    FileUtils.mkdir_p(dir_name) unless File.directory?(dir_name)
    logger = ActiveSupport::Logger.new(file_name)

    counter = 0

    logger.info "Reindexing #{model_name}: #{uris.count}"
    uris.each do |uri|
      work = ActiveFedora::Base.find(ActiveFedora::Base.uri_to_id(uri))
      logger.info "\t reindexing #{work.id}"
      begin
        work.update_index
        counter += 1
      rescue => e
        logger.info "Failed to reindex #{work.id}: #{e.message}"
      end
    end
    logger.info "Total indexed: #{counter}"
    logger.info 'Done'
  end
end
