# frozen_string_literal: true

module ScholarsArchive
  # downloads controller
  class DownloadsController < Hyrax::DownloadsController
    include ScholarsArchive::DownloadAnalyticsBehavior
    # Customize the :read ability in your Ability class, or override this method.
    # Hydra::Ability#download_permissions can't be used in this case because it assumes
    # that files are in a LDP basic container, and thus, included in the asset's uri.
    def authorize_download!
      authorize! :download, params[asset_param_key]
      # Deny access if the work containing this file is restricted by a workflow
      return unless workflow_restriction?(file_set_parent(params[asset_param_key]), ability: current_ability)
      return if valid_bot?
      raise Hyrax::WorkflowAuthorizationException
    rescue CanCan::AccessDenied, Hyrax::WorkflowAuthorizationException
      unauthorized_image = Rails.root.join("app", "assets", "images", "unauthorized.png")
      send_file unauthorized_image, status: :unauthorized
    end

    # 'ir.library.oregonstate.edu,ir-staging.library.oregonstate.edu,test.lib.oregonstate.edu:3000'
    def valid_bot?
      ENV.fetch('URI_TURNSTILE_BYPASS', '').split(',').include?(request.domain) || allow_listed_ip_addr?
    end

    def allow_listed_ip_addr?
      ips = ENV.fetch('IP_TURNSTILE_BYPASS', '') # '127.0.0.1-127.255.255.255,66.249.64.0-66.249.79.255'
      ranges = ips.split(',')
      ranges.each do |range|
        range = range.split('-')
        range = (IPAddr.new(range[0]).to_i..IPAddr.new(range[1]).to_i)
        return true if range.include?(IPAddr.new(request.remote_ip).to_i)
      end
      false
    end
  end
end
