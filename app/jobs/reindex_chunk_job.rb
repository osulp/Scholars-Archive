# frozen_string_literal: true

# reindexes chunks of uris
class ReindexChunkJob < ScholarsArchive::ApplicationJob
  queue_as :reindex

  # rubocop:disable Metrics/MethodLength
  def perform(uris)
    counter = 0
    logger = Rails.logger

    logger.info "Reindexing #{uris.count} URIs"
    uris.each do |uri|
      work = ActiveFedora::Base.find(ActiveFedora::Base.uri_to_id(uri))
      logger.info "\t reindexing #{work.id}"
      work.update_index
      counter += 1
    # rubocop:disable Style/RescueStandardError
    rescue => e
      logger.info "Failed to reindex #{work.id}: #{e.message}" unless work.nil?
      logger.info "Failed to reindex a work: #{e.message}; #{uri}" if work.nil?
      next
    end
    # rubocop:enable Style/RescueStandardError
    logger.info "Total indexed: #{counter}/#{uris.count}"
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
