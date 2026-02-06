# frozen_string_literal: true

module ScholarsArchive
  # MAILER: A human subject data mailer application
  class UserAttestationMailer < ApplicationMailer
    # METHOD: Create an email and send a report to the reviewer
    def user_attestation_mail(user_email: email)
      @user = email
      # MAIL: Email out to couple recipients
      mail(to: @user, subject: 'Work Needs Accessibility Support.')
    end
  end
end
