namespace :scholars_archive do
  desc 'Generate primo recommender export'
  task :convert_creators => [ :environment ] do
    require 'csv'

    file_name = "#{Date.today}-creator-migration.log"
    logger = Logger.new(File.join(Rails.root, 'log', file_name))

    # Iterate over csv first for migrated works
    CSV.foreach(File.join(Rails.root, 'dspace_creator_order.csv'), :headers => true) do |row|#Pull data from file
      # Set work and handle as empty string unless it is already assigned with something
      work ||= ""
      handle ||= ""

      puts row

      # Check if we are on a new work or the first work
      unless handle.blank? || handle == row["handle"]
        #If we are on a new work and it isnt the first row, then check the previous work and see if the creators are the same length and the new creators
        unless work.creators.length == work.nested_ordered_creators.length
          # Report that the amount of creators is different than the amount of nested_ordered_creators
          logger.warn("MISSMATCH_TYPE: NUMBER_OF_CREATORS\n")
          logger.warn("Work was found to have a missmatch in the creators.\n")
          logger.warn("WORK_ID: #{work.id}\n")
          logger.warn("CREATORS: #{work.creators.first}\n")
          logger.warn("DSPACE_CREATORS: #{work.nested_ordered_creators.map{ |c| c.creator.first }}\n")
          logger.warn("======================================================================================================\n")
        end
      end

      puts row["handle"]
      uri = RSolr.solr_escape("http://hdl.handle.net/#{row["handle"]}")
      query_string = "replaces_ssim:#{uri}"
      doc = ActiveFedora::SolrService.query(query_string)

      puts doc

      puts doc.first["id"].to_s

      begin
        # Query for object in database.
        work = ActiveFedora::Base.find(doc.first["id"])
        check_and_update_work(work, row, logger)
      rescue => e
        logger.info "\t\t failed to update work id #{doc["id"]}, error found:"
        logger.info "\t\t #{e.message}"
      end
    end

    # Query solr for all docs without handles
    docs = ActiveFedora::SolrService.query('creator_tesim:* AND -has_model_ssim:FileSet')

    # Iterate over all docs
    docs.each do |doc|
      # Find work based on ID
      unless doc["nested_ordered_creator_label_ssim"]

        begin
          # Find work based on ID
          work = ActiveFedora::Base.find(doc["id"])
          update_work(work, logger)
        rescue => e
          logger.info "\t\t failed to update work id #{doc["id"]}, error found:"
          logger.info "\t\t #{e.message}"
        end
      end
    end
  end

  logger.info "DONE"
end

def check_and_update_work(work, row, logger)
  # Check if the works creators contains the current name
  if !work.creator.include?(row["text_value"])
    # Report miss match
    logger.warn("MISSMATCH_TYPE: MISSING CREATOR\n")
    logger.warn("Name from DSpace was not found on this work.\n")
    logger.warn("WORK_ID: #{work.id}\n")
    logger.warn("CREATORS: #{work.creator.first}\n")
    logger.warn("DSPACE_CREATOR: #{row["text_value"]}\n")
    logger.warn("======================================================================================================")
  end

  # Add the current name and place as a nested ordered creator to the work.
  nested_creator = { :index => (row["place"].to_i - 1), :creator => row["text_value"] }
  work.nested_ordered_creator_attributes = [nested_creator]

  logger.info "\t saving nested ordered creator #{nested_creator.to_s} from dpace for work #{work.id}"

  if work.save
    logger.info "\t update for work id #{work.id} completed successfully"
  else
    logger.info "\t failed to update work id #{work.id} on save"
  end
end

def update_work(work, logger)
  ordered_creators = []

  if work.respond_to?(:nested_ordered_creator_attributes=) && work.respond_to?(:nested_ordered_creator) 
  # Iterate over the creators
    work.creator.each_with_index do |creator, i|

    # Translate creators over to nested ordered creators
      ordered_creators << {
        :index => i.to_s,
        :creator => creator.to_s
      }
    end

    work.nested_ordered_creator_attributes = ordered_creators

    logger.info "\t migrating creators #{work.creator.to_s} to nested ordered creators #{ordered_creators.to_s} for work #{work.id}"

    if work.save
      logger.info "\t update for work id #{work.id} completed successfully"
    else
      logger.info "\t failed to update work id #{work.id} on save"
    end
  end
end
