module ScholarsArchive
  module Workflow
    class DepositedNotification < Hyrax::Workflow::AbstractNotification
      private

      def subject
        'Deposit has been approved'
      end

      def message
        "Your deposit: #{title} (#{link_to work_id, document_path}) was approved by #{user.user_key} and is now live in ScholarsArchive@OSU. #{comment}"
      end

      def users_to_notify
        user_key = ActiveFedora::Base.find(work_id).depositor
        super << ::User.find_by(email: user_key)
      end
    end
  end
end