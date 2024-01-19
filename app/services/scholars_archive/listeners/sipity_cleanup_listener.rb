# frozen_string_literal: true

module ScholarsArchive
  module Listeners
    ##
    # Listens for object deleted events and cleans up associated Sipity Entity + Sipity Entity Specific Responsibilities
    class SipityCleanupListener
      # Called when 'object.deleted' event is published
      # @param [Dry::Events::Event] event
      # @return [void]
      def on_object_deleted(event)
        sipity_entity = Sipity::Entity.find_by('proxy_for_global_id like ?', "%/#{event[:id]}")
        Hyrax.logger.info("Deleting Sipity Entity Responsibilities for #{event[:id]}")
        sipity_entity.entity_specific_responsibilities.map(&:delete)
        Hyrax.logger.info("Sipity Entity Responsibilities for #{event[:id]} deleted now deleting Sipity Entity #{event[:id]}")
        sipity_entity.delete
        Hyrax.logger.info("Sipity Entity #{event[:id]} Deleted")
      rescue StandardError => e
        Hyrax.logger.warn "Failed to delete sipity entity for #{event[:id]}. " \
                          'This entity might be orphaned.' \
                          "\n\t#{e.message}"
      end
    end
  end
end
