module ScholarsArchive
  module Workflow
    class DepositReceivedNotification < Hyrax::Workflow::AbstractNotification
      private

      def subject
        'Thank you for your deposit to ScholarsArchive@OSU'
      end

      def message
        "ScholarsArchive@OSU has received your deposit: #{title} (#{link_to work_id, document_path}). Your item is under review by repository administrators. You will be notified if your deposit requires additional changes and/or when your deposit is live in the repository. \n\n #{comment}"
      end

      def users_to_notify
        super << user
      end
    end
  end
end
