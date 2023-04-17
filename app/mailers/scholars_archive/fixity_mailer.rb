# frozen_string_literal: true

module ScholarsArchive
  # MAILER: A fixity mailer application
  class FixityMailer < ApplicationMailer
    # METHOD: Create an email and send a report to the user
    def report_email
      @user = params[:user]
      @fixity_data = params[:data]
      mail(to: @user.email, subject: 'Scholars Archive: Fixity Report')
    end
  end
end
