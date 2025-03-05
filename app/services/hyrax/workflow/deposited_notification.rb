module Hyrax
  module Workflow
    class DepositedNotification < AbstractNotification
      def initialize(entity, comment, user, recipients)
        @doi = entity.proxy_for.doi
      end

      private
  
      def subject
        I18n.t('hyrax.notifications.workflow.deposited.subject')
      end

      def message
        I18n.t('hyrax.notifications.workflow.deposited.message',
                title: "#{title} (#{doi})}",
                link: (link_to work_id, document_path),
                user: user.user_key,
                comment: comment)
      end

      def users_to_notify
        user_key = @entity.proxy_for.depositor

        super << ::User.find_by_user_key(user_key)
      end
    end
  end
end