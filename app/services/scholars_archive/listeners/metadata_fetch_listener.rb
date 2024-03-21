# frozen_string_literal: true

module ScholarsArchive
  module Listeners
    # Listens for metadata update events and enqueues metadata fetch jobs
    # FetchGraphWorker provides redundancy in case DeepIndexingService fails
    # However, for duration of migration, disable FGW
    class MetadataFetchListener
      ##
      # @param event [Dry::Event]
      def on_object_metadata_updated(event)
        FetchGraphWorker.perform_in(1.minute, event[:object].id, event[:object].depositor)
      end
    end
  end
end
