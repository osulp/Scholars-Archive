# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScholarsArchive::TorrentFormController, type: :controller do
  let(:user) { User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false) } }
  routes { Hyrax::Engine.routes }

  before do
    @file = fixture_file_upload('app/assets/images/default.png', 'image/png')
  end

  let(:required_params) do
    {
      email: 'rose@timetraveler.org',
      description: 'Test description',
      error_message: 'Error description',
      file_item: @file,
      additional_item: @file
    }
  end
  let(:torrent_form) { ScholarsArchive::TorrentForm.new(required_params) }

  before { sign_in(user) }

  # TEST #1: Check if recaptcha works
  describe '#check_recaptcha' do
    before do
      controller.instance_variable_set(:@torrent_form, torrent_form)
    end

    context 'when recaptcha is enabled' do
      let(:params) { required_params }

      before do
        allow(controller).to receive(:is_recaptcha?).and_return(true)
      end

      context 'and the recaptcha is not verified' do
        before do
          allow(controller).to receive(:verify_recaptcha).and_return(false)
        end

        it 'returns false and throws an error' do
          expect(controller.check_recaptcha).to eq(false)
        end
      end

      context 'and the recaptcha is verified' do
        before do
          allow(controller).to receive(:verify_recaptcha).and_return(true)
        end

        it 'returns a true value' do
          expect(controller.check_recaptcha).to eq(true)
        end
      end
    end

    context 'when recaptcha is not enabled' do
      let(:params) { required_params }

      before do
        allow(controller).to receive(:is_recaptcha?).and_return(false)
      end

      it 'returns true and processes the email normally' do
        expect(controller.check_recaptcha).to eq(true)
      end
    end
  end
end
