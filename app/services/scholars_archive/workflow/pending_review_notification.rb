# frozen_string_literal: true

module ScholarsArchive
  module Workflow
    # Pending review
    class PendingReviewNotification < ScholarsArchive::Workflow::AbstractNotification
      private

      def subject
        'Deposit needs review'
      end

      def message
        "The item: #{title} (#{link_to work_id, citeable_url}) was deposited by #{user.user_key} and is awaiting review. #{comment}"
      end
    end
  end
end
