# frozen_string_literal: true

module Hyrax
  module Workflow
    # Notifies User of pending deletion
    class PendingDeletionNotification < AbstractNotification
      private

      def subject
        'Deletion request needs review'
      end

      def message
        "A deletion request for #{title} (#{link_to work_id, document_path}) was made by #{user.user_key} and is awaiting approval with the following comments: #{comment}"
      end

      def users_to_notify
        super << user
      end
    end
  end
end
