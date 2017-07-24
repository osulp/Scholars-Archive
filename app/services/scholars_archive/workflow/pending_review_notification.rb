module ScholarsArchive
  module Workflow
    class PendingReviewNotification < Hyrax::Workflow::AbstractNotification
      private

      def subject
        'Deposit needs review'
      end

      def message
        "The item: #{title} (#{link_to work_id, document_path}) was deposited by #{user.user_key} and is awaiting review. #{comment}"
      end

      def users_to_notify
        super
      end
    end
  end
end