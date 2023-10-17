# frozen_string_literal: true

module ScholarsArchive
  # Article controller behavior
  module ArticlesControllerBehavior
    # MODIFY: Add in a way to send email after create success
    def create
      set_other_option_values
      work_persist = super
      article_email_info if work_persist
      work_persist
    end

    # METHOD: A function to get the info to send out to the depositor on their article
    def article_email_info
      # VARIABLE: Create a hash to pass the data into mail
      article_email = { title: curation_concern.title,
                        creator: curation_concern.depositor,
                        article_id: curation_concern.id,
                        link_url: main_app.polymorphic_url(curation_concern) }

      # SEND: Send the email out to the depositor
      send_email_on_article(article_email)
    end

    # METHOD: Send out email to the depositor let them know it is deposited
    def send_email_on_article(email_data)
      # MAILER: Enable mailer so it can send out the email
      ActionMailer::Base.perform_deliveries = true

      # USER: Get user email to send out
      email_recipient = User.where(username: curation_concern.depositor).map(&:email).join

      # DELIVER: Delivering the email to the reviewer
      ScholarsArchive::ArticlesNotificationMailer.with(user_email: email_recipient, data: email_data).email_article_depositor.deliver_now
    end
  end
end
