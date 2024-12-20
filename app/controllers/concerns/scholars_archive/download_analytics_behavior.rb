# frozen_string_literal: true

module ScholarsArchive
  # analytics behavior
  module DownloadAnalyticsBehavior
    extend ActiveSupport::Concern

    included do
      after_action :track_download, only: :show

      def track_download
        # Add in special case to ignore collection of analytic data
        return if Hyrax.config.google_analytics_id.blank? || params[:file].to_s.downcase == 'thumbnail' || request.path.include?('/admin/')

        # Staccato works with Google Analytics v1 api:
        # https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
        # Staccato on Github: https://github.com/tpitale/staccato
        begin
          # GA4 collection url
          base_uri = URI('https://www.google-analytics.com/g/collect')
          # Update host header for submission to GA4
          headers = {
            'Accept-Language': request.headers['HTTP_ACCEPT_LANGUAGE'],
            'Host': 'www.google-analytics.com',
            'Origin': request.headers['HTTP_ORIGIN'],
            'Referer': request.headers['HTTP_REFERER'],
            'User-Agent': request.headers['HTTP_USER_AGENT']
          }

          file_download_params = {
            'v': '2', # Protocol version
            'tid': Hyrax.config.google_analytics_id.to_s, # Tracking ID
            'cid': SecureRandom.uuid.to_s, # Client ID
            'dl': request.url.to_s, # Document Location URL
            'dh': request.server_name.to_s, # Document Host Name
            'dr': request.referrer.to_s, # Document Referrer
            'dt': params[:id].to_s, # Document Title
            'en': 'Download', # Event Name
            'ep.event_category': 'Files', # Event Category
            'ep.event_label': params[:id].to_s # Event Label
          }
          # Combine params as query params and base URI
          file_download_uri = URI.parse([base_uri, URI.encode_www_form(file_download_params)].join('?'))
          # Submit File Download
          ::Net::HTTP.post(file_download_uri, nil, headers)

          # Disable Staccato tracking until Staccato can be updated for GA4
          # tracker = Staccato.tracker(Hyrax.config.google_analytics_id)
          # tracker.event(category: 'Files',
          #               action: 'Downloaded',
          #               label: params[:id],
          #               linkid: request.url,
          #               user_agent: request.headers['User-Agent'],
          #               user_ip: request.remote_ip)
          # # Setting the title to be the download id provides an easy way to group
          # # and count on GA
          # tracker.pageview(path: request.url,
          #                  hostname: request.server_name,
          #                  title: params[:id],
          #                  user_agent: request.headers['User-Agent'],
          #                  user_ip: request.remote_ip)
          # tracker.track
        rescue StandardError => e
          Rails.logger.error "Analytics Error: #{e.message} : #{e.backtrace}"
          nil
        end
      end
    end
  end
end
