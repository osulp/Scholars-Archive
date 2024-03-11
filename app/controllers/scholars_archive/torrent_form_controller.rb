# frozen_string_literal: true

module ScholarsArchive
  # CLASS: Torrent Form Controller
  class TorrentFormController < ApplicationController
    # ACTION: Before page load, build the form with all the params
    before_action :build_torrent_form
    invisible_captcha only: [:create]
    layout 'homepage'

    def new; end

    def create
      render :new
    end

    # NOTE: Override if needed to perform after email delivery
    def after_deliver; end

    private

    # METHOD: Create a new form with all the params
    def build_torrent_form
      @torrent_form = ScholarsArchive::TorrentForm.new(torrent_form_params)
    end

    # METHOD: Permits all the required params
    def torrent_form_params
      return {} unless params.key?(:torrent_form)

      params.require(:torrent_form).permit(:torrent_method, :name, :description, :error_message)
    end
  end
end
