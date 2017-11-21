namespace :scholars_archive do
  desc "Fix visibility during embargo"
  task fix_visible: :environment do
    fix_embargo
  end

  def fix_embargo
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
          w.ordered_members.to_a.each do |f|
            if f.embargo && f.visibility_during_embargo && f.visibility_during_embargo == "restricted"
              logger.info "\tfixing visibility_during_embargo for child work #{f.id} (parent work #{id})"
              f.visibility_during_embargo = "authenticated"
              f.embargo.save
              if f.save
                logger.info "\tsuccessfully changed visibility_during_embargo from restricted to #{f.visibility_during_embargo} for child work #{f.id} (parent work #{id})"
                counter += 1
              else
                logger.info "\tunable to change visibility_during_embargo for child work #{f.id} (parent work #{id})"
              end
            else
              logger.info "\t child work #{f.id} does not have visibility_during_embargo set, current visibility = #{f.visibility_during_embargo} (parent work #{id})"
            end
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

  def fix_visibility
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/fix-visibility-#{datetime_today}.log")
    to_be_fixed = YAML.load_file('lib/tasks/visible_to_be_fixed.yml')["visible_to_be_fixed"] || {}

    counter = 0
    to_be_fixed.each do |work|
      id = work["id"]
      logger.info "fixing visibility in work #{work["id"]}"
      begin
        model = work["has_model_ssim"].constantize
        w = model.find(id)
        # update visibility
        if w.visibility == "open"
          w.read_groups = ["registered"]
          w.ordered_members.to_a.each do |f|
            if f.visibility == "open"
              logger.info "\tfixing visibility for child work #{f.id} (parent work #{id})"
              f.read_groups = ["registered"]
              if f.save
                logger.info "\tsuccessfully changed visibility from open to #{f.visibility} for child work #{f.id} (parent work #{id})"
                counter += 1
              else
                logger.info "\tunable to change visibility for child work #{f.id} (parent work #{id})"
              end
            else
              logger.info "\t child work #{f.id} does not have open visibility, current visibility = #{f.visibility} (parent work #{id})"
            end
          end
          if w.save
            logger.info "\tsuccessfully changed visibility from open to #{w.visibility} for work #{id})"
            counter += 1
          else
            logger.info "\tunable to change visibility for work #{id}"
          end
        else
          logger.info "\t work #{id} does not have open visibility, current visibility = #{w.visibility}"
        end

      rescue => e
        logger.info "\tfailed to fix visibility for #{id}: #{e.message}"
      end
    end
    logger.info "Done. Fixed a total of #{counter} works (including ordered_members)."
  end
end