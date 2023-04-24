# frozen_string_literal: true

module ScholarsArchive
  # MAILER: A human subject data mailer application
  class HumanDataMailer < ApplicationMailer
    # METHOD: Create an email and send a report to the reviewer
    def email_on_human_data
      @human_data_info = params[:data]
      mail(to: Hyrax.config.contact_email, subject: 'Dataset Alert! Human Subject Data Included')
    end
  end
end
