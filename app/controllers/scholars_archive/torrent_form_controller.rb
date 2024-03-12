# frozen_string_literal: true

module ScholarsArchive
  # CLASS: Torrent Form Controller
  class TorrentFormController < ApplicationController
    # ACTION: Before page load, build the form with all the params
    include ScholarsArchive::TorrentFormRecaptchaBehavior
    before_action :build_torrent_form
    invisible_captcha only: [:create]
    layout 'homepage'

    def new; end

    def create
      # CHECK: See if the form is valid
      if @torrent_form.valid?
        # IF: If recaptcha present, then send the email and reload the new form for submission
        if check_recaptcha
          ScholarsArchive::TorrentMailer.torrent_contact(@torrent_form).deliver_now
          flash.now[:notice] = 'Thank you for your message!'
          after_deliver
          @torrent_form = ScholarsArchive::TorrentForm.new
        end
      else
        flash.now[:error] = 'Sorry, this message was not sent successfully.'
      end
      render :new
    rescue RuntimeError => e
      handle_create_exception(e)
    end

    # METHOD: Create a handler for the exception
    def handle_create_exception(exception)
      logger.error("Contact form failed to send: #{exception.inspect}")
      flash.now[:error] = 'Sorry, this message was not delivered.'
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
      return {} unless params.key?(:scholars_archive_torrent_form)
      params.require(:scholars_archive_torrent_form).permit(:torrent_method, :email, :description, :error_message, :file_item, :additional_item)
    end
  end
end
