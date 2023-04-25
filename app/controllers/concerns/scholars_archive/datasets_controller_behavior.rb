# frozen_string_literal: true

module ScholarsArchive
  # dataset controller behavior
  module DatasetsControllerBehavior
    def create
      set_other_option_values
      check_data = find_remove_human_data
      value_item = super
      check_human_data(check_data) if value_item
      value_item
    end

    # METHOD: Check to see if the works have human data
    def check_human_data(file_check)
      # CHECK: Checking if the human data variable hold true to send email
      # rubocop:disable Style/GuardClause
      if file_check.downcase.include?('true')
        # VARIABLE: Create a hash to pass the data into mail
        human_data_email = { title: curation_concern.title,
                             creator: curation_concern.depositor,
                             dataset_id: curation_concern.id,
                             link_url: main_app.polymorphic_url(curation_concern) }

        # SEND: Send the email out and remove variable
        send_email_on_human_data(human_data_email)
      end
      # rubocop:enable Style/GuardClause
    end

    # METHOD: Get the value out of the human data and remove it
    def find_remove_human_data
      get_data = params['dataset']['human_data']
      params['dataset'].delete('human_data')
      get_data
    end

    # METHOD: Send out email to the reviewer if data have human subject in it
    def send_email_on_human_data(email_data)
      # MAILER: Enable mailer so it can send out the email
      ActionMailer::Base.perform_deliveries = true

      # USER: Get user in a list to send
      email_recipients = ['sarah.imholt@oregonstate.edu', 'cara.key@oregonstate.edu', 'clara.llebot@oregonstate.edu', Hyrax.config.contact_email]

      # DELIVER: Delivering the email to the reviewer
      email_recipients.each do |i|
        ScholarsArchive::HumanDataMailer.with(user_mail: i, data: email_data).email_on_human_data.deliver_now
      end
    end
  end
end
