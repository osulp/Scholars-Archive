module ScholarsArchive
  class DownloadsController < Hyrax::DownloadsController
    include ScholarsArchive::DownloadAnalyticsBehavior
  end
end
