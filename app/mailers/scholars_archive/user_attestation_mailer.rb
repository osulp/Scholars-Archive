# frozen_string_literal: true

module ScholarsArchive
  # MAILER: A mailer for accessibility attestations
  class UserAttestationMailer < ApplicationMailer
    # METHOD: Create an email and send to user
    def user_attestation_mail(email)
      @user = email
      # MAIL: Email out to couple recipients
      mail(to: @user, subject: 'ScholarsArchive@OSU: Your request for an accessibility consultation')
    end
  end
end
