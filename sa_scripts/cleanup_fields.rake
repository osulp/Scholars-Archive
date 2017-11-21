namespace :scholars_archive do
  desc "Cleanup URI enabled fields"
  task :cleanup_uri_fields => :environment do
    # puts "Cleanup works from json files at tmp/works_needing_updates/"
    # input files
    # tmp_json_path = Rails.root / 'tmp' / 'works_needing_updates'
    # input_json_file = 'graduate_thesis_or_dissertation.json'
    # input_json_file = 'undergraduate_thesis_or_project.json'

    # Note: load solr results from json file (first approach)
    # read files and parse
    # file = File.open(tmp_json_path / input_json_file)
    # json = file.read
    # data = JSON.parse(json)

    cleanup_gtds
  end

  def custom_degree_field_mapping
    {
        "Family Resource Managment" => "http://opaquenamespace.org/ns/osuDegreeFields/sJvBNFOf",
        "Water Resources Policy Management" => "http://opaquenamespace.org/ns/osuDegreeFields/5ifb2xho",
        "Ocean, Earth and Atmospheric Sciences" => "http://opaquenamespace.org/ns/osuDegreeFields/5pnGgj8o",
        "Ocean, Earth, and Atmospheric Sciences" => "http://opaquenamespace.org/ns/osuDegreeFields/5pnGgj8o",
        "Chemistry (Organic)" => "http://opaquenamespace.org/ns/osuDegreeFields/MjnsYuhF",
        "Botony" => "http://opaquenamespace.org/ns/osuDegreeFields/cL3TfKTX",
        "Household Adminstration" => "http://opaquenamespace.org/ns/osuDegreeFields/MjxCbYg4",
        "Entomolgy" => "http://opaquenamespace.org/ns/osuDegreeFields/nHvyZi7s",
        "Animal Science." => "http://opaquenamespace.org/ns/osuDegreeFields/ZfhfkCsy",
        "Electrical Engineering and Computer Engineering" => "http://opaquenamespace.org/ns/osuDegreeFields/Iyd25vfm",
        "xElectrical and Computer Engineering" => "http://opaquenamespace.org/ns/osuDegreeFields/Iyd25vfm",
        "Forest Resouces" => "http://opaquenamespace.org/ns/osuDegreeFields/n74DImcH",
        "Apparel, Interiors and Merchandising" => "http://opaquenamespace.org/ns/osuDegreeFields/O5sXIL5K",
        "Apparel, Interiors, Housing and Merchandising" => "http://opaquenamespace.org/ns/osuDegreeFields/aAynzoLm",
        "Biology" => "http://opaquenamespace.org/ns/osuDegreeFields/3KjCghJI",
        "Botony and Plant Pathology" => "http://opaquenamespace.org/ns/osuDegreeFields/tcOW28Iw",
        "Clothing Textiles and Related Arts" => "http://opaquenamespace.org/ns/osuDegreeFields/Qkh08a4r",
        "Clothing, Textiles and Related Arts" => "http://opaquenamespace.org/ns/osuDegreeFields/Qkh08a4r",
        "Commerical Education" => "http://opaquenamespace.org/ns/osuDegreeFields/QNQ5QxZK",
        "Counselng and Guidance" => "http://opaquenamespace.org/ns/osuDegreeFields/3UEPxWet",
        "Crop Science" => "http://opaquenamespace.org/ns/osuDegreeFields/dS4cz8yW",
        "Electical and Computer Engineering" => "http://opaquenamespace.org/ns/osuDegreeFields/Iyd25vfm",
        "Entomology'" => "http://opaquenamespace.org/ns/osuDegreeFields/nHvyZi7s",
        "Environmental Geology" => "http://opaquenamespace.org/ns/osuDegreeFields/9ZofPob7",
        "Fish and Game Manangement" => "http://opaquenamespace.org/ns/osuDegreeFields/bDPSKEm0",
        "Food and Dairy Technolog" => "http://opaquenamespace.org/ns/osuDegreeFields/ustgFwKe",
        "Food and Science Technology" => "http://opaquenamespace.org/ns/osuDegreeFields/qyorwK13",
        "Home Ecomomics" => "http://opaquenamespace.org/ns/osuDegreeFields/GDbPCXVb",
        "Home Econcomics" => "http://opaquenamespace.org/ns/osuDegreeFields/GDbPCXVb",
        "Home Economic Education" => "http://opaquenamespace.org/ns/osuDegreeFields/SzK6MXFZ",
        "Industrial Manufacturing Engineering" => "http://opaquenamespace.org/ns/osuDegreeFields/yByL0ezS",
        "n Food Science and Technology" => "http://opaquenamespace.org/ns/osuDegreeFields/qyorwK13",
        "Oceangraphy" => "http://opaquenamespace.org/ns/osuDegreeFields/S3LgKhiC",
        "Pharmaceutical Sciences" => "http://opaquenamespace.org/ns/osuDegreeFields/yx7BL9lj",
        "Post-Secondary Education" => "http://opaquenamespace.org/ns/osuDegreeFields/xQklC4xJ",
        "Renewable Materials" => "http://opaquenamespace.org/ns/osuDegreeFields/M58XBehe",
        "Sport and Exercise Science" => "http://opaquenamespace.org/ns/osuDegreeFields/UgjXGtBh",
        "the Forest Products" => "http://opaquenamespace.org/ns/osuDegreeFields/Ea1pi1cX",
        "Veterinary Sciences" => "http://opaquenamespace.org/ns/osuDegreeFields/c5N0uCrh",
        "Vocational-Technical Education" => "http://opaquenamespace.org/ns/osuDegreeFields/pYPsxQHg",
        "Water Resource Policy and Management" => "http://opaquenamespace.org/ns/osuDegreeFields/5ifb2xho",
    }
  end

  def custom_degree_grantors_mapping
    {
        "Oregon State University" => "http://id.loc.gov/authorities/names/n80017721",
        "Oregon State College" => "http://id.loc.gov/authorities/names/n82022628",
        "Oregon Agricultural College" => "http://id.loc.gov/authorities/names/n95078079",
        "Oregon State Agricultural College" => "http://id.loc.gov/authorities/names/n87850581",
        "Oregon State College in Chemistry" => "http://id.loc.gov/authorities/names/n82022628",
    }
  end

  def fields_present?(new_attributes, required_flag)
    if required_flag
      new_attributes[:degree_field].present? && new_attributes[:degree_grantors].present?
    else
      new_attributes[:degree_field].present? || new_attributes[:degree_grantors].present?
    end
  end

  def cleanup_process(solr_query_str:, model_class:, required_flag:)
    data = ActiveFedora::SolrService.get(solr_query_str, :rows => 100000)

    # Create logger
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/sa-cleanup-#{model_class.to_s}-#{datetime_today}.log")
    logger.info "Cleaning up degree_field and/or degree_grantors in #{model_class.to_s}"

    # retrieve options needed for update action
    degree_field_service = ScholarsArchive::DegreeFieldService.new
    degree_field_options = degree_field_service.select_all_options.to_a
    osu_uri = "http://id.loc.gov/authorities/names/n80017721"
    osc_uri = "http://id.loc.gov/authorities/names/n82022628"

    counter = 0

    # perform updates
    logger.info "work count to update: #{data["response"]["numFound"]}"

    data["response"]["docs"].each do |doc|
      logger.info "cleaning up work #{doc["id"]}"

      if doc["has_model_ssim"] && doc["has_model_ssim"].select(&:present?).count.positive?
        work_model = model_class
        new_attributes = {}

        begin
          work = work_model.find(doc["id"])

          # given degree field in text only, find uri and set uri in place for degree_field
          # and skip them if they are already uris in fedora
          if work.degree_field.present? && (!work.degree_field.start_with? "http")
            input_label = work.degree_field.to_s
            if custom_degree_field_mapping[input_label]
              uri_from_label = custom_degree_field_mapping[input_label]
            else
              input_label_clean = input_label.downcase.gsub("&", "and").tr(".","")
              uri_from_label = degree_field_options.select { |label, uri| label.split('-').first.strip.downcase.tr(".","") == input_label_clean }.flatten.second
            end

            if uri_from_label
              logger.info "\t ready to update from \"#{work.degree_field.to_s}\" to #{uri_from_label}"
              new_attributes[:degree_field] = uri_from_label
            else
              logger.info "\t no match found for degree_field \"#{work.degree_field.to_s}\" in work with id #{doc["id"]}"
            end
          end

          # given degree grantors in text only, set to osu_uri if text equals "Oregon State University"
          # and skip them if they are already uris in fedora
          if work.degree_grantors.present? && (!work.degree_grantors.start_with? "http")
            input_label = work.degree_grantors.to_s
            if custom_degree_grantors_mapping[input_label]
              uri_from_label = custom_degree_grantors_mapping[input_label]
              logger.info "\t ready to update from #{input_label} to #{uri_from_label}"
              new_attributes[:degree_grantors] = uri_from_label
            else
              logger.info "\t no match found for degree_grantor \"#{input_label}\" in work with id #{doc["id"]}"
            end
          end

          # log degree_fields that are already uris
          if work.degree_field.present? && (work.degree_field.start_with? "http")
            logger.info "\t degree_field \"#{work.degree_field.to_s}\" is already a uri in work with id #{doc["id"]}"
          end

          # log degree_field that are already uris
          if work.degree_grantors.present? && (work.degree_grantors.start_with? "http")
            logger.info "\t degree_grantor \"#{work.degree_grantors.to_s}\" is already a uri in work with id #{doc["id"]}"
          end

          # commit changes needed
          if fields_present?(new_attributes, required_flag)
            work.degree_field = new_attributes[:degree_field] if new_attributes[:degree_field]
            work.degree_grantors = new_attributes[:degree_grantors] if new_attributes[:degree_grantors]

            # skip embargo validation on expired embargoes
            if work.embargo && work.embargo.embargo_release_date < DateTime.now
              validate_embargo = false
              work.embargo.save(validate: validate_embargo)
              logger.info "\t expired embargo for #{doc["id"]}"
            else
              validate_embargo = true
            end

            if work.save!(validate: validate_embargo)
              logger.info "\t update for work id #{doc["id"]} completed successfully with #{new_attributes}"
              counter += 1
            else
              logger.info "\t failed to update work id #{doc["id"]} with #{new_attributes} on save"
            end
          else
            logger.info "\t no updates completed for work #{doc["id"]}, new_attributes set: #{new_attributes}"
          end
        rescue => e
          logger.info "\t failed to update work id #{doc["id"]} with #{new_attributes}, error found:"
          logger.info "\t #{e.message}"
        end
      end
    end

    logger.info "Total items successfully cleaned up: #{counter}"
    logger.info "Done"
  end

  def cleanup_gtds
    # Note: another way to query solr to get input data (second best approach)
    # data = ActiveFedora::SolrService.get("-degree_field_tesim:http* AND has_model_ssim:GraduateThesisOrDissertation", :rows => 100000)

    # Note: querying solr without embargoed records (we will deal with those later since they are a smaller set: ~207 for GraduateThesisOrDissertation)
    # data = ActiveFedora::SolrService.get("-degree_field_tesim:http* AND -hasEmbargo_ssim:[* TO *] AND has_model_ssim:GraduateThesisOrDissertation", :rows => 100000)

    # Note: querying solr with embargoed records only (for this case, we are skipping embargo validation since the embargo actor only accepts future embargo_release_date)
    # solr_query_str: "-degree_field_tesim:http* AND degree_field_tesim:[* TO *] AND hasEmbargo_ssim:[* TO *] AND has_model_ssim:GraduateThesisOrDissertation",

    # Note: querying solr on degree_field_tesim and skip empty value
    cleanup_process(solr_query_str: "-degree_field_tesim:http* AND degree_field_tesim:[* TO *] AND has_model_ssim:GraduateThesisOrDissertation",
                    model_class: GraduateThesisOrDissertation,
                    required_flag: true)
  end

  def cleanup_utps
    cleanup_process(solr_query_str: "-degree_grantors_tesim:http* AND degree_grantors_tesim:[* TO *] AND has_model_ssim:UndergraduateThesisOrProject",
                    model_class: UndergraduateThesisOrProject,
                    required_flag: false)
  end

end