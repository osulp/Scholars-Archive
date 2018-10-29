namespace :scholars_archive do
  desc "Correct visibility_after_embargo of migrated items that set as open access"
  task correct_visibility_after_embargo: :environment do
    handle_list = ENV['handle_list']
    correct_visibility_after_embargo(handle_list)
  end

  def correct_visibility_after_embargo(handle_list)
    handle_file = File.join(File.dirname(__FILE__), handle_list)
    handles_to_process = []
    File.readlines(handle_file).each do |line|
      handles_to_process.push(line.chomp.strip)
    end
    handles_to_process.sort!

    # Create logger
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p')
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/correct-visibilityafterembargo-#{datetime_today}.log")
    logger.info "Correcting visibility after embargo"

    handles_to_process.each do |handle|
      solr_query_str = "replaces_tesim:\"#{handle}\""
      doc = ActiveFedora::SolrService.query(solr_query_str, {:rows => 1}).first
      begin
        work_model = doc["has_model_ssim"].first.constantize
        work = work_model.find(doc["id"])
        # if embargo_release_date_dtsi not exists,
        # then check embargo_history_ssim: if exists (indicates embargo is lifted), change visibility_ssi from its current value to 'open'
        if doc['embargo_release_date_dtsi'].nil? && doc['embargo_history_ssim'].present?
          work.visibility = "open"
          work.embargo.save!
          work.save!
          logger.info "Correct visibility for handle: #{handle} to 'open', the original embargo history is #{doc['embargo_history_ssim']}"
          work.ordered_members.to_a.each do |f|
            f.visibility = 'open'
            f.embargo.save
            if f.save
              logger.info "Correct visibility of fileset for handle: #{handle} to 'open', #{f}"
            else
              logger.info "Unsuccefully correct visibility of fileset for handle: #{handle} to 'open', #{f}"
            end
          end
        end
        # if embargo_release_date_dtsi exists (indicates embargoed currently),
        # then change visibility_after_embargo_ssim from 'authenticated' to 'open'
        if doc['embargo_release_date_dtsi'].present?
          work.visibility_after_embargo = "open"
          work.embargo.save!
          work.save!
          logger.info "Correct visibility_after_embargo for handle: #{handle} to 'open', the embargo release date is #{doc['embargo_release_date_dtsi']}"
          work.ordered_members.to_a.each do |f|
            f.visibility_after_embargo = 'open'
            f.embargo.save
            if f.save
              logger.info "Correct visibility_after_embargo of fileset for handle: #{handle} to 'open', #{f}"
            else
              logger.info "Unsuccefully correct visibility_after_embargo of fileset for handle: #{handle} to 'open', #{f}"
            end
          end
        end
      rescue => e
        logger.info "failed to correct visibility for handle: #{handle} for: #{e.message}"
      end
    end
  end
end