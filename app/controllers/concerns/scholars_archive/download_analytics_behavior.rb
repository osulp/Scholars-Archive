# frozen_string_literal: true

module ScholarsArchive
  # analytics behavior
  module DownloadAnalyticsBehavior
    extend ActiveSupport::Concern

    included do
      after_action :track_download, only: :show

      def track_download
        # Return early since Staccato is temporarily broken for GA4
        return

        unless Hyrax.config.google_analytics_id.blank?
          # Staccato works with Google Analytics v1 api:
          # https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
          # Staccato on Github: https://github.com/tpitale/staccato
          begin
            tracker = Staccato.tracker(Hyrax.config.google_analytics_id)
            tracker.event(category: 'Files',
                          action: 'Downloaded',
                          label: params[:id],
                          linkid: request.url,
                          user_agent: request.headers['User-Agent'],
                          user_ip: request.remote_ip)
            # Setting the title to be the download id provides an easy way to group
            # and count on GA
            tracker.pageview(path: request.url,
                             hostname: request.server_name,
                             title: params[:id],
                             user_agent: request.headers['User-Agent'],
                             user_ip: request.remote_ip)
            tracker.track
          rescue StandardError => e
            Rails.logger.error "Staccato Error: #{e.message} : #{e.backtrace}"
            return nil
          end
        end
      end
    end
  end
end
