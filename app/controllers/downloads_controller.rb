class DownloadsController < ApplicationController
  include Sufia::DownloadsControllerBehavior

  after_filter :track_download, :only => :show

  def track_download
    if Sufia.config.respond_to? :google_analytics_id
      #Staccato works with Google Analytics v1 api:
      #https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
      #
      #Staccato on Github: https://github.com/tpitale/staccato
      tracker = Staccato.tracker(Sufia.config.google_analytics_id)
      tracker.event(category: 'downloads',
                    action: 'direct-link',
                    label: request.url,
                    #using linkid because it seemed generic enough yet allows
                    #for text values
                    linkid: params[:id])
      # Setting the title to be the download id provides an easy way to group
      # and count on GA
      tracker.pageview(path: request.url,
                       hostname: request.server_name,
                       title: params[:id])
      tracker.track
    end
  end
end
