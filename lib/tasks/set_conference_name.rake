namespace :scholars_archive do
  desc "Set conference name field on known dspace collections"
  task :set_conference_name => :environment do
    se_conf_values
  end

  def collection_conf_name_mapping
    {
        "Report C" => "Biennial Conference on University Education in Natural Resources",
        "Report D" => "Code4Lib",
        "Report G" => "International Institute of Fisheries Economics & Trade",
        "Information Circular (Forest Research Laboratory)" => "International Institute of Fisheries Economics & Trade",
        "Hill Family Foundation Series" => "International Institute of Fisheries Economics & Trade",
        "MS non-thesis Research Papers (EECS)" => "International Institute of Fisheries Economics & Trade",
        "Historical Records (Student Affairs)" => "International Institute of Fisheries Economics & Trade",
        "2008: Toward One Oregon" => "International Institute of Fisheries Economics & Trade",
        "Schedule of Classes (Cascades Campus)" => "International Institute of Fisheries Economics & Trade",
        "Schedule of Classes (Extended Campus)" => "International Institute of Fisheries Economics & Trade",
        "Papers (Rural-Urban Connections)" => "International Institute of Fisheries Economics & Trade",
        "Historical Records (Music)" => "International Institute of Fisheries Economics & Trade",
        "Lane County Historian" => "International Institute of Fisheries Economics & Trade",
        "Bibliographic Series (Forest Research Laboratory)" => "International Institute of Fisheries Economics & Trade",
        "Annual Cruise (includes OAC Forestry Club Annual)" => "International Institute of Fisheries Economics & Trade",
        "Transactions of the Annual Re-union of the Oregon Pioneer Association" => "International Institute of Fisheries Economics & Trade",
        "Theses, Dissertations and Student Research Papers (Forest Ecosystems and Society & Forest Science)" => "International Institute of Fisheries Economics & Trade",
        "Theses, Dissertations and Student Research Papers (Sustainable Forest Management, Forest Engineering, & Forest Management)" => "International Institute of Fisheries Economics & Trade",
        "Registration Information Handbook" => "International Institute of Fisheries Economics & Trade",
        "Fact Sheets (Rural Studies Program)" => "International Institute of Fisheries Economics & Trade",
        "Community Studies (Rural Studies Program)" => "International Institute of Fisheries Economics & Trade",
        "W.I.R.E.'d Zine" => "International Institute of Fisheries Economics & Trade",
        "Reports (Independent Multidisciplinary Science Team)" => "International Institute of Fisheries Economics & Trade",
        "Transboundary Freshwater Dispute Database Publications" => "International Institute of Fisheries Economics & Trade",
        "Index of Selected Journal Articles Pertaining to the Forest Products Industries" => "International Institute of Fisheries Economics & Trade",
        "Daily Barometer" => "International Institute of Fisheries Economics & Trade",
        "Robert Lundeen Library Faculty Development Award" => "International Institute of Fisheries Economics & Trade",
        "Oregon Vegetable Digest" => "International Institute of Fisheries Economics & Trade",
        "Oregon Motorist" => "International Institute of Fisheries Economics & Trade",
        "Oregon Native Son" => "International Institute of Fisheries Economics & Trade",
        "Imprint, Oregon" => "International Institute of Fisheries Economics & Trade",
        "Wild Cascades" => "International Institute of Fisheries Economics & Trade",
        "Honors Theses (EECS)" => "International Institute of Fisheries Economics & Trade",
        "4-H" => "International Institute of Fisheries Economics & Trade",
        "Extension Service -- Circulars / Extension Circulars" => "International Institute of Fisheries Economics & Trade",
        "Theses, Dissertations and Student Research Papers (Speech Communication)" => "International Institute of Fisheries Economics & Trade",
        "Agricultural Experiment Station -- Circulars of Information" => "International Institute of Fisheries Economics & Trade",
        "Extension Service -- Pacific Northwest Extension Publishing" => "International Institute of Fisheries Economics & Trade",
        "Publications and Reports (INR)" => "International Institute of Fisheries Economics & Trade",
        "Oregon Oddities and Items of Interest" => "North American Association of Fisheries Economists",
        "Extension Service -- Miscellaneous / Educational Materials" => "North American Association of Fisheries Economists",
        "Agricultural Experiment Station -- Bulletins / Station Bulletins" => "North American Association of Fisheries Economists",
        "Timber Lines" => "North American Association of Fisheries Economists",
        "Northwest National Marine Renewable Energy Center (NNMREC) Publications" => "Oregon Marine Renewable Energy Environmental Science",
        "Case Studies (Forest Research Laboratory)" => "Oregon Water Conference",
        "Contributions in Education and Outreach (Forest Research Laboratory)" => "Pacific Northwest Insect Management Conference",
        "Papers in Forest Policy" => "Pacific Northwest Insect Management Conference",
        "Water Resources Graduate Program Theses and Dissertations" => "Pacific Northwest Insect Management Conference",
        "Institute for Water and Watersheds (2005-present)" => "Pacific Northwest Insect Management Conference",
        "Theses, Dissertations and Student Research Papers (School of Forestry, pre - 1984)" => "Pacific Northwest Insect Management Conference",
        "Faculty Research Publications (Fisheries and Wildlife)" => "Pacific Northwest Insect Management Conference",
        "Faculty Research Publications (History)" => "Pacific Northwest Insect Management Conference",
        "Faculty Research Publications (College of Forestry & Oregon Forest Research Laboratory)" => "Pacific Northwest Insect Management Conference",
        "Vet Gazette e-newsletter" => "Pacific Northwest Insect Management Conference",
        "Office of Government Relations" => "Pacific Northwest Insect Management Conference",
        "Addresses and Speeches (President's Office)" => "Pacific Northwest Insect Management Conference",
        "Faculty Research Publications (Anthropology)" => "Pacific Northwest Insect Management Conference",
        "Marine Resource Management" => "Pacific Northwest Insect Management Conference",
        "CEOAS Reports" => "Toward One Oregon",
        "Marine Economics Data Sheets" => "Western Dry Kiln Association"
    }
  end

  def set_conf_values
    # Create logger
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/sa-cleanup-#{model_class.to_s}-#{datetime_today}.log")
    logger.info "Setting conference names for known dspace collections"
    counter = 0

    # perform updates
    collection_conf_name_mapping.each do |collection, conf_name|
      solr_query_str = "dspace_collection_tesim:\"#{conf_name}\""
      docs = ActiveFedora::SolrService.query(solr_query_str, {:rows => 100000})
      logger.info "work count to update for collection: \"#{collection}\": #{docs.count}"

      docs.each do |doc|
        logger.info "\t cleaning up work #{doc["id"]}"

        if doc["has_model_ssim"] && doc["has_model_ssim"].select(&:present?).count.positive?
          work_model = doc["has_model_ssim"].first

          begin
            work = work_model.find(doc["id"])

            # commit changes needed
            work.conference_name = conf_name

            if work.save!(validate: true)
              logger.info "\t update for work id #{doc["id"]} completed successfully"
              counter += 1
            else
              logger.info "\t failed to update work id #{doc["id"]} with #{new_attributes} on save"
            end

          rescue => e
            logger.info "\t failed to update work id #{doc["id"]} with #{new_attributes}, error found:"
            logger.info "\t #{e.message}"
          end
        end
      end
    end

    logger.info "Total items successfully cleaned up: #{counter}"
    logger.info "Done"
  end
end