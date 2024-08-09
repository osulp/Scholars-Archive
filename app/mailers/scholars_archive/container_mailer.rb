# frozen_string_literal: true

module ScholarsArchive
  # MAILER: A Container/archive mailer application
  class ContainerMailer < ApplicationMailer
    # METHOD: Create an email and send a report to the user
    def report_email
      attachments['filesets_inventory.csv'] = File.read('./tmp/filesets_inventory.csv') if File.exist?('./tmp/filesets_inventory.csv')
      attachments['filesets_failed.csv'] = File.read('./tmp/filesets_failed.csv') if File.exist?('./tmp/filesets_failed.csv')
      mail(to: params[:to], subject: 'Scholars Archive: Archive/Container Files Inventory Report')
    end
  end
end
