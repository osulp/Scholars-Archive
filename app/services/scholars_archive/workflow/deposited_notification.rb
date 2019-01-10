# frozen_string_literal: true

module ScholarsArchive
  module Workflow
    # Deposit notification
    class DepositedNotification < ScholarsArchive::Workflow::AbstractNotification
      private

      def subject
        'Deposit has been approved'
      end

      def message
        "Your deposit: #{title} (#{link_to work_id, citeable_url}) was approved by #{user.user_key} and is now live in ScholarsArchive@OSU. #{comment} \n\n Citeable URL: #{citeable_url}"
      end

      def users_to_notify
        user_key = ActiveFedora::Base.find(work_id).depositor
        [::User.find_by(username: user_key)]
      end
    end
  end
end
