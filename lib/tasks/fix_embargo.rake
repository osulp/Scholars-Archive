namespace :scholars_archive do
  desc "Fix visibility during embargo"
  task fix_embargo: :environment do
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/fix-embargo-#{datetime_today}.log")
    to_be_fixed = YAML.load_file('lib/tasks/handles_to_be_fixed.yml')["handles_to_be_fixed"] || {}

    counter = 0
    to_be_fixed.each do |work|
      id = work["id"]
      logger.info "Fixing visibility_during_embargo in work #{work["id"]}"
      begin
        model = work["has_model_ssim"].constantize
        w = model.find(id)
        # update embargo
        if w.embargo && w.visibility_during_embargo
          if w.visibility_during_embargo == "restricted"
            w.visibility_during_embargo = "authenticated"
            w.embargo.save
            w.save
            counter += 1
            logger.info "\tSuccessfully fixed embargo in work #{work["id"]}: updated visibility_during_embargo from restricted to authenticated"
          else
            logger.info "\tUnable to fix embargo visibility in work #{work["id"]}: visibility_during_embargo is set to #{w.visibility_during_embargo}"
          end
        else
          logger.info "\tUnable to fix embargo visibility in work #{work["id"]}: embargo and/or visibility_during_embargo not defined"
        end

      rescue => e
        logger.info "\tFailed to fix embargo for #{work["id"]}: #{e.message}"
      end
    end
    logger.info "Done. Fixed a total of #{counter} works."
  end
end