# frozen_string_literal: true

# reindexes chunks of uris
class ReindexChunkJob < ScholarsArchive::ApplicationJob
  queue_as :default

  def perform(uris)
    counter = 0
    logger = Rails.logger

    logger.info "Reindexing #{uris.count} URIs"
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
    logger.info "Total indexed: #{counter}/#{uris.count}"
    logger.info 'Done'
  end
end
