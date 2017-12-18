namespace :scholars_archive do
  desc "Set conference name field on known dspace collections"
  task :set_conference_name => :environment do
    set_conf_values
  end

  def collection_conf_name_mapping
    {
        "Biennial Conference on University Education in Natural Resources. (7th : 2008, Corvallis, OR)" => "Biennial Conference on University Education in Natural Resources",
        "code4lib Conference 2006" => "Code4Lib",
        "Conference Materials (IIFET 2000)" => "International Institute of Fisheries Economics & Trade",
        "Fish and Aquaculture Sectors' Development (IIFET 2000)" => "International Institute of Fisheries Economics & Trade",
        "Fishery Management (IIFET 2000)" => "International Institute of Fisheries Economics & Trade",
        "Markets and Trade (IIFET 2000)" => "International Institute of Fisheries Economics & Trade",
        "Modeling and Economic Theory (IIFET 2000)" => "International Institute of Fisheries Economics & Trade",
        "Aquaculture (IIFET 2000)" => "International Institute of Fisheries Economics & Trade",
        "Fishing Sector Behavior and Activities (IIFET 2000)" => "International Institute of Fisheries Economics & Trade",
        "Conference Papers and Presentations (IIFET 2012)" => "International Institute of Fisheries Economics & Trade",
        "Posters (IIFET 2000)" => "International Institute of Fisheries Economics & Trade",
        "Conference Materials (IIFET 2008)" => "International Institute of Fisheries Economics & Trade",
        "Fishery Management (IIFET 2008)" => "International Institute of Fisheries Economics & Trade",
        "Markets and Trade (IIFET 2008)" => "International Institute of Fisheries Economics & Trade",
        "Aquaculture (IIFET 2008)" => "International Institute of Fisheries Economics & Trade",
        "Modeling and Economic Theory (IIFET 2008)" => "International Institute of Fisheries Economics & Trade",
        "Special Topics (IIFET 2008)" => "International Institute of Fisheries Economics & Trade",
        "Fish and Aquaculture Sectors' Development (IIFET 2008)" => "International Institute of Fisheries Economics & Trade",
        "Posters (IIFET 2008)" => "International Institute of Fisheries Economics & Trade",
        "Conference Papers and Presentations (IIFET 2010)" => "International Institute of Fisheries Economics & Trade",
        "Conference Materials (IIFET 2006)" => "International Institute of Fisheries Economics & Trade",
        "Aquaculture (IIFET 2006)" => "International Institute of Fisheries Economics & Trade",
        "Markets and Trade (IIFET 2006)" => "International Institute of Fisheries Economics & Trade",
        "Modeling and Economic Theory (IIFET 2006)" => "International Institute of Fisheries Economics & Trade",
        "Fish and Aquaculture Sectors' Development (IIFET 2006)" => "International Institute of Fisheries Economics & Trade",
        "Fishery Management (IIFET 2006)" => "International Institute of Fisheries Economics & Trade",
        "Special Topics (IIFET 2006)" => "International Institute of Fisheries Economics & Trade",
        "Policy Day (IIFET 2006)" => "International Institute of Fisheries Economics & Trade",
        "Conference Papers and Presentations (IIFET 2014)" => "International Institute of Fisheries Economics & Trade",
        "Conference Materials (IIFET 2014)" => "International Institute of Fisheries Economics & Trade",
        "Conference Papers and Presentations (IIFET 2004)" => "International Institute of Fisheries Economics & Trade",
        "Conference Materials (IIFET 2004)" => "International Institute of Fisheries Economics & Trade",
        "Conference Materials (IIFET 1996)" => "International Institute of Fisheries Economics & Trade",
        "Conference Papers and Presentations (IIFET 1996)" => "International Institute of Fisheries Economics & Trade",
        "Conference Materials (IIFET 2002)" => "International Institute of Fisheries Economics & Trade",
        "Conference Papers and Presentations (IIFET 2002)" => "International Institute of Fisheries Economics & Trade",
        "Conference Papers and Presentations (IIFET 2016)" => "International Institute of Fisheries Economics & Trade",
        "Conference Materials (IIFET 2016)" => "International Institute of Fisheries Economics & Trade",
        "Conference Materials (IIFET 2012)" => "International Institute of Fisheries Economics & Trade",
        "Conference Materials (NAAFE Forum 2015)" => "North American Association of Fisheries Economists",
        "Conference Papers and Presentations (NAAFE Forum 2015)" => "North American Association of Fisheries Economists",
        "Conference Materials (NAAFE Forum 2017)" => "North American Association of Fisheries Economists",
        "Conference Papers and Presentations (NAAFE Forum 2017)" => "North American Association of Fisheries Economists",
        "Oregon Marine Renewable Energy Environmental Science Conference Proceedings" => "Oregon Marine Renewable Energy Environmental Science",
        "Oregon Tribal Archives Institute 2012" => "Oregon Tribal Archives Institute",
        "The Oregon Water Conference 2011: Evaluating and Managing Water Resources in a Climate of Uncertainty" => "Oregon Water Conference",
        "64th Annual Pacific Northwest Insect Management Conference (2005)" => "Pacific Northwest Insect Management Conference",
        "65th Annual Pacific Northwest Insect Management Conference (2006)" => "Pacific Northwest Insect Management Conference",
        "66th Annual Pacific Northwest Insect Management Conference (2007)" => "Pacific Northwest Insect Management Conference",
        "67th Annual Pacific Northwest Insect Management Conference (2008)" => "Pacific Northwest Insect Management Conference",
        "68th Annual Pacific Northwest Insect Management Conference (2009)" => "Pacific Northwest Insect Management Conference",
        "69th Annual Pacific Northwest Insect Management Conference (2010)" => "Pacific Northwest Insect Management Conference",
        "70th Annual Pacific Northwest Insect Management Conference (2011)" => "Pacific Northwest Insect Management Conference",
        "71st Annual Pacific Northwest Insect Management Conference (2012)" => "Pacific Northwest Insect Management Conference",
        "72nd Annual Pacific Northwest Insect Management Conference (2013)" => "Pacific Northwest Insect Management Conference",
        "73rd Annual Pacific Northwest Insect Management Conference (2014)" => "Pacific Northwest Insect Management Conference",
        "74th Annual Pacific Northwest Insect Management Conference (2015)" => "Pacific Northwest Insect Management Conference",
        "75th Annual Pacific Northwest Insect Management Conference (2016)" => "Pacific Northwest Insect Management Conference",
        "76th Annual Pacific Northwest Insect Management Conference (2017)" => "Pacific Northwest Insect Management Conference",
        "2008: Toward One Oregon" => "Toward One Oregon",
        "Western Dry Kiln Association Proceedings" => "Western Dry Kiln Association"
    }
  end

  def set_conf_values
    # Create logger
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/sa-cleanup-set-conf-name-#{datetime_today}.log")
    logger.info "Setting conference names for known dspace collections"
    counter = 0

    # perform updates
    collection_conf_name_mapping.each do |collection, conf_name|
      solr_query_str = "dspace_collection_tesim:\"#{collection}\""
      docs = ActiveFedora::SolrService.query(solr_query_str, {:rows => 100000})
      logger.info "work count to update for collection: \"#{collection}\": #{docs.count}"

      docs.each do |doc|
        logger.info "\t ready to update conference_name to \"#{conf_name}\" for work #{doc["id"]} in collection \"#{collection}\""

        if doc["has_model_ssim"] && doc["has_model_ssim"].select(&:present?).count.positive? && ['Article', 'ConferenceProceedingsOrJournal'].include?(doc["has_model_ssim"].first)
          work_model = doc["has_model_ssim"].first.constantize

          begin
            work = work_model.find(doc["id"])

            # double check collection name
            if work.dspace_collection.first == collection
              # commit changes needed
              work.conference_name = conf_name
              # skip embargo validation on expired embargoes
              if work.embargo && work.embargo.embargo_release_date < DateTime.now
                validate_embargo = false
                work.embargo.save(validate: validate_embargo)
                logger.info "\t\t expired embargo for #{doc["id"]}"
              else
                validate_embargo = true
              end

              if work.save!(validate: validate_embargo)
                logger.info "\t\t update for work id #{doc["id"]} completed successfully"
                counter += 1
              else
                logger.info "\t\t failed to update conference_name to \"#{conf_name}\" on work id #{doc["id"]} (#{collection}) on save"
              end
            else
              logger.info "\t\t unable to update work id #{doc["id"]} has_model_ssim: #{doc["has_model_ssim"]} dspace_collection \"#{ work.dspace_collection }\" doesn't match with \"#{collection}\""
            end

          rescue => e
            logger.info "\t\t failed to update work id #{doc["id"]}, error found:"
            logger.info "\t\t #{e.message}"
          end
        else
          logger.info "\t\t unable to update work id #{doc["id"]} has_model_ssim: #{doc["has_model_ssim"]}"
        end
      end
    end

    logger.info "Total items successfully updated: #{counter}"
    logger.info "Done"
  end
end