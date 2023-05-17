# frozen_string_literal: true

# reindexes chunks of uris
class ReplacePredicateJob < ScholarsArchive::ApplicationJob
  queue_as :default

  # rubocop:disable Metrics/MethodLength
  def perform(ids_and_value, old_predicate, metadata_field)
    counter = 0
    logger = Rails.logger

    logger.info "Updating #{ids_and_value.count} works"
    logger.info ids_and_value
    ids_and_value.each do |id, value|
      work = ActiveFedora::Base.find(id)
      old_predicate_statement = [work.resource.rdf_subject, ::RDF::URI.new(old_predicate), nil]

      unless work.resource.graph.query(old_predicate_statement).statements.empty?
        orm = Ldp::Orm.new(work.ldp_source)

        logger.info "Work found #{work.id}. Updating #{metadata_field}. Setting to new value: #{value}"
        work.send("#{metadata_field}=", value)

        logger.info 'Saving work'
        if work.save
          logger.info "Work saved. Removing old #{metadata_field}. Pulling graph from fedora"

          logger.info "Deleting #{metadata_field} from graph"
          orm.graph.delete(old_predicate_statement)

          logger.info 'Saving the graph'
          if orm.save
            logger.info 'Graph saved successfully'
            counter += 1
          else
            logger.error "Something went wrong with removing old value from graph #{work.id}"
          end
        else
          logger.error "Something went wrong adding new value #{work.id}"
        end
      end
    # rubocop:disable Style/RescueStandardError
    rescue => e
      logger.info "Failed to update #{work.id}: #{e.message}"
      next
    end
    # rubocop:enable Style/RescueStandardError
    logger.info "Total works updated: #{counter}/#{ids_and_value.count}"
  end
  # rubocop:enable Metrics/MethodLength
end
