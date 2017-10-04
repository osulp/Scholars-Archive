module ScholarsArchive
  module DownloadAnalyticsBehavior
    extend ActiveSupport::Concern

    included do
      after_action :track_download, only: :show

      def track_download
        unless Hyrax.config.google_analytics_id.blank?
          # Staccato works with Google Analytics v1 api:
          # https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
          # Staccato on Github: https://github.com/tpitale/staccato
          tracker = Staccato.tracker(Hyrax.config.google_analytics_id)
          tracker.event(category: 'Files', action: 'Downloaded', label: "hyrax:#{params[:id]}", linkid: request.url)
          # Setting the title to be the download id provides an easy way to group
          # and count on GA
          tracker.pageview(path: request.url, hostname: request.server_name, title: params[:id])
          tracker.track
        end
      end
    end
  end
end
