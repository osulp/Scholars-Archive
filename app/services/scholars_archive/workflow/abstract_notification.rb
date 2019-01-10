# frozen_string_literal: true

module ScholarsArchive
  module Workflow
    # Notifications
    class AbstractNotification < Hyrax::Workflow::AbstractNotification
      private

      def citeable_url
        Rails.application.routes.url_helpers.url_for(:only_path => false, :action => 'show', :controller => 'hyrax/'+document.model_name.plural, :host=> Rails.application.config.action_mailer.default_url_options[:host], protocol: 'https', id: work_id)
      end
    end
  end
end
