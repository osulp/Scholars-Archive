# frozen_string_literal: true

module ScholarsArchive
  # CLASS: Torrent Mailer for contacting the administrator
  class TorrentMailer < ApplicationMailer
    def torrent_contact(torrent_form)
      @torrent_form = torrent_form

      # Check for spam
      return if @torrent_form.spam?
      mail(@torrent_form.headers)
    end
  end
end
