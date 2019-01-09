# frozen_string_literal: true

module ScholarsArchive
  # downloads controller
  class DownloadsController < Hyrax::DownloadsController
    include ScholarsArchive::DownloadAnalyticsBehavior
  end
end
