# frozen_string_literal: true

module ScholarsArchive
  module Workflow
    # Advanced notification for Grad & Honors
    class AdvancedNotification < ScholarsArchive::Workflow::AbstractNotification
      def initialize(entity, comment, user, recipients)
        @doi = entity.proxy_for.doi
        super(entity, comment, user, recipients)
      end

      private

      def subject
        'ScholarsArchive@OSU Message: Deposit advanced'
      end

      def message
        "Your deposit: '#{title}' #{@doi} (#{link_to work_id, citeable_url}) was approved by #{user.user_key}. It is now live in ScholarsArchive@OSU review queue for a metadata check. You will get a message when it is live in the repository. \n\n
         #{comment} \n\n
         Thank you, \n
         ScholarsArchive@OSU Admin \n
         Oregon State University Libraries and Press"
      end

      def users_to_notify
        user_key = ActiveFedora::Base.find(work_id).depositor
        [::User.find_by(username: user_key)]
      end
    end
  end
end
