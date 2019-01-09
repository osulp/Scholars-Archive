# frozen_string_literal: true

module ScholarsArchive
  # single use link controller
  class SingleUseLinksViewerController < Hyrax::SingleUseLinksViewerController
    include ScholarsArchive::DownloadAnalyticsBehavior
    after_action :track_download, only: :download
  end
end
