# frozen_string_literal: true

module ScholarsArchive
  # MAILER: A Container/archive mailer application
  class ContainerMailer < ApplicationMailer
    # METHOD: Create an email and send a report to the user
    def report_email
      attachments['filesets_inventory.txt'] = File.read('./tmp/inventory.txt') if File.exist?('./tmp/inventory.txt')
      mail(to: params[:to], subject: 'Scholars Archive: Archive/Container Files Inventory Report')
    end
  end
end
