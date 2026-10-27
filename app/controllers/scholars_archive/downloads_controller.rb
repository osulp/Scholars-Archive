# frozen_string_literal: true

module ScholarsArchive
  # downloads controller
  class DownloadsController < Hyrax::DownloadsController
    include ScholarsArchive::DownloadAnalyticsBehavior
    include ScholarsArchive::BotDetectionBehavior
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
      unauthorized_image = Rails.root.join('app', 'assets', 'images', 'unauthorized.png')
      send_file unauthorized_image, status: :unauthorized
    end

    before_action :allow_page_caching
  end
end
