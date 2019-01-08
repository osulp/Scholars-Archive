# frozen_string_literal: true

module ScholarsArchive
  class DownloadsController < Hyrax::DownloadsController
    include ScholarsArchive::DownloadAnalyticsBehavior
  end
end
