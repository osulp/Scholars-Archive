# frozen_string_literal: true

module ScholarsArchive
  # MAILER: A human subject data mailer application
  class AttestationMailer < ApplicationMailer
    # METHOD: Create an email and send a report to the reviewer
    def accessibility_attestation_mail(user_email: email, user_work: user_work)
      @user = email
      @work = user_work
      # MAIL: Email out to couple recipients
      mail(to: ENV.fetch('SCHOLARSARCHIVE_ADMIN_EMAIL', 'scholarsarchive@oregonstate.edu'), subject: 'Work Needs Accessibility Support.')
    end
  end
end
