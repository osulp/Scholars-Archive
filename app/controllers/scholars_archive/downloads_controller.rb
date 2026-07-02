# frozen_string_literal: true

module ScholarsArchive
  # downloads controller
  class DownloadsController < Hyrax::DownloadsController
    include ScholarsArchive::DownloadAnalyticsBehavior
    before_action :allow_page_caching
  end
end
