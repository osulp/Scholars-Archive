# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScholarsArchive::DownloadsController, type: :controller do
  before do
    Hyrax.config.google_analytics_id = 'blah'
  end

  it 'has the method for tracking analytics for download' do
    stub_request(:post, 'http://www.google-analytics.com/collect').to_return(status: 200, body: '', headers: {})
    expect(controller).to respond_to(:track_download)
    expect(controller.track_download).to be_a_kind_of Net::HTTPOK
  end

  context 'when rescuing errors from Staccato' do
    let(:error) { StandardError }

    before do
      allow(Staccato).to receive(:tracker).and_raise(error)
      stub_request(:post, 'http://www.google-analytics.com/collect').to_return(status: 200, body: '', headers: {})
    end

    it 'responds to track_download' do
      expect(controller).to respond_to(:track_download)
    end

    it 'rescues errors from Staccato' do
      expect(controller.track_download).to be_nil
    end
  end
end
