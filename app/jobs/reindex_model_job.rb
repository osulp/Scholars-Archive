# frozen_string_literal: true

# reindexes all works of a single model
class ReindexModelJob < ScholarsArchive::ApplicationJob
  queue_as :reindex

  def perform(model_name, uris)
    counter = 0
    logger = Rails.logger

    logger.info "Reindexing #{model_name}: #{uris.count}"
    uris.each do |uri|
      work = ActiveFedora::Base.find(ActiveFedora::Base.uri_to_id(uri))
      logger.info "\t reindexing #{work.id}"
      work.update_index
      counter += 1
    rescue => e
      logger.info "Failed to reindex #{work.id}: #{e.message}"
      next
    end
    logger.info "Total indexed: #{counter}"
    logger.info 'Done'
  end
end
