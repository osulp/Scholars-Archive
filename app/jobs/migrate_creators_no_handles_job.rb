# frozen_string_literal: true

class MigrateCreatorsNoHandlesJob < ScholarsArchive::ApplicationJob
  queue_as :default

  def perform
    datetime_today = DateTime.now.strftime('%Y-%m-%d-%H-%M-%p') # "10-27-2017-12-59-PM"
    file_name = "#{datetime_today}-creator-migration-no-handles.log"
    logger = Logger.new(File.join(Rails.root, 'log', file_name))

    # Query solr for all docs without handles (exclude docs with handles)
    docs = ActiveFedora::SolrService.query('creator_tesim:* AND -has_model_ssim:FileSet AND -replaces_tesim:[* TO *]', {rows: 100000})

    # Iterate over all docs
    docs.each do |doc|
      # Find work based on ID
      unless doc['nested_ordered_creator_label_ssim'].present?

        begin
          # Find work based on ID
          work = ActiveFedora::Base.find(doc['id'])
          update_work(work, logger)
        rescue => e
          logger.info "\t\t failed to update work id #{doc["id"]}, error found:"
          logger.info "\t\t #{e.message}"
        end
      end
    end
    logger.info 'DONE'
  end

  def update_work(work, logger)
    ordered_creators = []

    if work.respond_to?(:nested_ordered_creator_attributes=) && work.respond_to?(:nested_ordered_creator)
      # Iterate over the creators
      work.creator.each_with_index do |creator, i|
        # Translate creators over to nested ordered creators
        ordered_creators << {
          index: i.to_s,
          creator: creator.to_s
        }
      end

      work.nested_ordered_creator_attributes = ordered_creators

      logger.info "\t migrating creators #{work.creator.to_a.to_s} to nested ordered creators #{ordered_creators.to_s} for work #{work.id} (#{work.model_name.to_s})"

      if work.save
        logger.info "\t update for work id #{work.id} (#{work.model_name.to_s}) completed successfully"
      else
        logger.info "\t failed to update work id #{work.id} (#{work.model_name.to_s}) on save"
      end
    end
  end
end
