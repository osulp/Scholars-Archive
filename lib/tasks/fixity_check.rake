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
    latest_file = ChecksumAuditLog.where("updated_at >= ?", start_time)
    file_checked = latest_file.count
    file_passed = latest_file.where("passed = true").count
    file_failed = latest_file.where("passed = false").count

    # QUERY #2: Get all the ids that failed via checking with fixity
    latest_file.each do |c|
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
    if (failed_arr.empty?)
      Rails.logger.info "None"
    else
      failed_arr.each do |f|
        Rails.logger.info "#{f.to_s}"
      end
    end

    # HASH: Create a ruby hash to store data in and make it easier to pass it into mail
    fixity_data = {start_time: start_time,
                   end_time: end_time,
                   num_file: file_checked,
                   file_pass: file_passed,
                   file_fail: file_failed,
                   fail_arr: failed_arr}

    # MAILER: Enable mailer so Fixity can send out the email now
    ActionMailer::Base.perform_deliveries = true

    # CHECK: Check to make sure Scholars Archive email exist
    if (User.where(email: 'scholarsarchive@oregonstate.edu').empty?)
      user_email = User.first
    else
      user_email = User.where(email: 'scholarsarchive@oregonstate.edu')
    end

    # DELIVER: Delivering the email to the user
    ScholarsArchive::FixityMailer.with(user: user_email, data: fixity_data).report_email.deliver_now
  end
end