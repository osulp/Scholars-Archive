# frozen_string_literal: true

module ScholarsArchive
  # MAILER: A Container/archive mailer application
  class ContainerMailer < ApplicationMailer
    # METHOD: Create an email and send a report to the user
    def report_email
      @inventory_data = params[:data]
      mail(to: params[:to], subject: 'Scholars Archive: Archive/Container Files Inventory Report')
    end
  end
end
