# frozen_string_literal: true

module ScholarsArchive
  # MAILER: A human subject data mailer application
  class HumanDataMailer < ApplicationMailer
    # METHOD: Create an email and send a report to the reviewer
    def email_on_human_data
      @human_data_info = params[:data]
      @email_recipients = [Hyrax.config.contact_email, 'imholts@oregonstate.edu', 'keyca@oregonstate.edu', 'llebotlc@oregonstate.edu']

      # LOOP: Loop through each email and send out to the Dataset Managers
      @email_recipients.each do |email_add|
        mail(to: email_add, subject: 'Dataset Alert! Human Subject Data Included')
      end
    end
  end
end
