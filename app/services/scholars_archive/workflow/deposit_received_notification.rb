# frozen_string_literal: true

module ScholarsArchive
  module Workflow
    # Received deposit
    class DepositReceivedNotification < ScholarsArchive::Workflow::AbstractNotification
      private

      def subject
        'Thank you for your deposit to ScholarsArchive@OSU'
      end

      def message
        "ScholarsArchive@OSU has received your deposit: #{title} (#{link_to work_id, citeable_url}). Your item is under review by repository administrators. You will be notified if your deposit requires additional changes and/or when your deposit is live in the repository. \n\n #{comment}"
      end

      # Add the user who initiated this action to the list of users being notified
      def users_to_notify
        [user]
      end
    end
  end
end
