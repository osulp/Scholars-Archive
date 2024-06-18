# frozen_string_literal: true

module ScholarsArchive
  module Workflow
    # Changes required
    class ChangesRequiredNotification < ScholarsArchive::Workflow::AbstractNotification
      private

      def subject
        'Your deposit requires changes'
      end

      def message
        "Your deposit #{title} (#{link_to work_id, citeable_url}) requires additional changes before it can be accepted. You need to be logged in to ScholarsArchive@OSU to access and make changes to your deposit. #{user.user_key} left you a comment: '#{comment}'"
      end

      def users_to_notify
        user_key = document.depositor
        [::User.find_by(username: user_key)]
      end
    end
  end
end
