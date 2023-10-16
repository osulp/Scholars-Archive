# frozen_string_literal: true

module ScholarsArchive
  # MAILER: A article mailer application
  class ArticlesNotificationMailer < ApplicationMailer
    # METHOD: Create an email and send a report to the reviewer
    def email_article_depositor
      # FETCH: Get the information to connect to the mailer
      @article_data = params[:data]
      @user_email = params[:user_email]

      # MAIL: Email out to couple recipients
      mail(to: @user_email, subject: '[Scholars Archive] - Article Deposit Notice')
    end
  end
end
