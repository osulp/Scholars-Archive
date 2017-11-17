namespace :scholars_archive do
  desc "Fix visibility during embargo"
  task fix_embargo: :environment do
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/fix-embargo-#{datetime_today}.log")
    to_be_fixed = YAML.load_file('lib/tasks/handles_to_be_fixed.yml')["handles_to_be_fixed"] || {}
    counter = 0
    to_be_fixed.each do |work|
      id = work["id"]
      handle = work["replaces_ssim"]
      begin
        model = work["has_model_ssim"].constantize
        w = model.find(id)
        # update embargo
        if w.visibility_during_embargo == "restricted"
          w.visibility_during_embargo = "authenticated"
          w.embargo.save
          w.save
          counter += 1
          logger.info "Successfully fixed embargo in work #{work["id"]}: updated visibility_during_embargo from #{work["visibility_during_embargo_ssim"]} to authenticated"
        end
      rescue => e
        logger.info "Failed to fix embargo for #{work["id"]}: #{e.message}"
      end

    end
  end
end