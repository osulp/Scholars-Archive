namespace :scholars_archive do
  desc "repository fixity check"
  task fixity: :environment do
    Rails.logger.warn "Running Hyrax::RepositoryFixityCheckService"

    # SETUP: Variables will be used in the case
    failed_arr = []

    # MAILER: Disable mailer so Fixity won't send out email while running check
    ActionMailer::Base.perform_deliveries = false

    # CREATE: Make a start time to know when Fixity starts
    start_time = Time.now

    # OVERRIDE: From Hyrax, add async option for Fixity check
    ::FileSet.find_each do |file_set|
      Hyrax::FileSetFixityCheckService.new(file_set, async_jobs: false).fixity_check
    end

    # CREATE: Make an end time to know when Fixity finish
    end_time = Time.now

    # QUERY #1: Query data from the ChecksumAuditLog
    file_passed = ChecksumAuditLog.where("passed = true").count
    file_failed = ChecksumAuditLog.where("passed = false").count
    file_checked = ChecksumAuditLog.count

    # QUERY #2: Get all the ids that failed via checking with fixity
    ChecksumAuditLog.find_each do |c|
      if (c.passed != true)
        failed_arr.append(c.file_set_id)
      end
    end

    # APPEND: Display an outro message saying Fixity is done checking
    Rails.logger.info "\n[COMPLETE] All fixity checks complete!\n"

    # APPEND: Attach additional information to the log
    Rails.logger.info "'START TIME': #{start_time.strftime("%B %-d, %Y %l:%M:%S:%L %p").to_s}"
    Rails.logger.info "'END TIME': #{end_time.strftime("%B %-d, %Y %l:%M:%S:%L %p").to_s}"
    Rails.logger.info "'No. of File Sets [CHECKED]': #{file_checked.to_s}"
    Rails.logger.info "'No. of File Sets [PASSED]': #{file_passed.to_s}"
    Rails.logger.info "'No. of File Sets [FAILED]': #{file_failed.to_s}\n"

    Rails.logger.info "'No. of File Sets [IDs] that failed':"
    if (failed_arr.length == 0)
      Rails.logger.info "None"
    else
      for i in failed_arr do
        Rails.logger.info "#{i.to_s}"
      end
    end

    # MAILER: Enable mailer so Fixity can send out the email now
    # ActionMailer::Base.perform_deliveries = true

    # DELIVER: Delivering the email to user
    # User.find_each do |user|
    #   ScholarsArchive::FixityMailer.with(user: user).report_email.deliver_now
    # end
  
    
    # TODO:
    # 5. Append log to email w/ finish time

    # 6. Send out email

  

  end
end