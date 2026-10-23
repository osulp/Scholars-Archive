# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScholarsArchive::SingleUseLinksViewerController, type: :controller do
  before do
    allow(Hyrax::Analytics.config).to receive(:analytics_id).and_return('UA-XXXXXXXX')
  end

  it 'has the method for tracking analytics for download' do
    stub_request(:post, %r{https://www.google-analytics.com/g/collect\?.*}).to_return(status: 200, body: '', headers: {})
    expect(controller).to respond_to(:track_download)
    expect(controller.track_download).to be_a_kind_of Net::HTTPOK
  end
end
