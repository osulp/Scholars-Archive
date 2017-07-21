module ScholarsArchive
  module Workflow
    class ChangesRequiredNotification < Hyrax::Workflow::AbstractNotification
      private

      def subject
        'Your deposit requires changes'
      end

      def message
        "Your deposit #{title} (#{link_to work_id, document_path}) requires additional changes before your deposit can be accepted into ScholarsArchive@OSU.\n\n #{user.user_key} left you a comment: '#{comment}'"
      end

      def users_to_notify
        user_key = document.depositor
        [::User.find_by(username: user_key)]
      end
    end
  end
end