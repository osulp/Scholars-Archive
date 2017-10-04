module ScholarsArchive
  class SingleUseLinksViewerController < Hyrax::SingleUseLinksViewerController
    include ScholarsArchive::DownloadAnalyticsBehavior
    after_action :track_download, only: :download
  end
end
