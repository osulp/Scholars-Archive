# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScholarsArchive::HandlesController, type: :controller do
  let(:work) { Default.new(title: ['blah'], id: 'asdfasdf') }
  let(:fileset) { FileSet.new(title: ['cat.jpg'], id: 'qwerqwer') }

  describe '#get handle_show' do
    context 'when a work exists with the proper handle' do
      before do
        allow(controller).to receive(:find_work).and_return(work)
      end

      it 'reroutes the user to the show page' do
        get :handle_show, params: { handle_prefix: '1957', handle_localname: '12345' }
        expect(response.status).to eq 302
      end
    end

    context 'when a work doesnt exist with the proper handle' do
      before do
        allow(controller).to receive(:find_work).and_return(nil)
      end

      it 'reroutes the user to work not found error page' do
        get :handle_show, params: { handle_prefix: '1957', handle_localname: '12345' }
        expect(response.status).to eq 404
      end
    end
  end

  describe '#get handle_download' do
    context 'when a work and its file set exists' do
      before do
        allow(controller).to receive(:find_work).and_return(work)
        allow(controller).to receive(:filesets_for_work).and_return([fileset])
      end

      it 'reroutes the user to the download link' do
        get :handle_download, params: { handle_prefix: '1957', handle_localname: '12345', file: 'cat.jpg' }
        expect(response).to redirect_to "/downloads/#{fileset.id}"
      end
    end

    context 'when a work does not exist with the proper handle' do
      before do
        allow(controller).to receive(:find_work).and_return(nil)
      end

      it 'reroutes the user to the work not found page' do
        get :handle_download, params: { handle_prefix: '1957', handle_localname: '12345', file: 'cat.jpg' }
        expect(response.status).to eq 404
      end
    end

    context 'when a work exists but it doesnt have the right file' do
      before do
        allow(controller).to receive(:find_work).and_return(work)
        allow(controller).to receive(:filesets_for_work).and_return([])
      end

      it 'reroutes the user to 404 file not found page' do
        get :handle_download, params: { handle_prefix: '1957', handle_localname: '12345', file: 'catasdf' }
        expect(response.status).to eq 404
      end
    end

    context 'when a work exists and returns too many file matches' do
      before do
        allow(controller).to receive(:find_work).and_return(work)
        allow(controller).to receive(:filesets_for_work).and_return([fileset, fileset])
      end

      it 'reroutes the user to the show page' do
        get :handle_download, params: { handle_prefix: '1957', handle_localname: '12345', file: 'cat.jpg' }
        expect(response.status).to eq 302
      end
    end
  end
end
