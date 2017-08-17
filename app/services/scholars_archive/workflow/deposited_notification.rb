module ScholarsArchive
  module Workflow
    class DepositedNotification < Hyrax::Workflow::AbstractNotification
      private

      def subject
        'Deposit has been approved'
      end

      def message
        "Your deposit: #{title} (#{link_to work_id, document_path}) was approved by #{user.user_key} and is now live in ScholarsArchive@OSU. #{comment} \n\n Citeable URL: #{citeable_url}"
      end

      def citeable_url
        Rails.application.routes.url_helpers.url_for(:only_path => false, :action => 'show', :controller => 'hyrax/'+document.model_name.plural, :host=> Rails.application.config.action_mailer.default_url_options[:host], id: work_id)
      end

      def users_to_notify
        user_key = ActiveFedora::Base.find(work_id).depositor
        [::User.find_by(username: user_key)]
      end
    end
  end
end