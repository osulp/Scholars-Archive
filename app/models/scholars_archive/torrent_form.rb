# frozen_string_literal: true

module ScholarsArchive
  # CLASS: Torrent Form
  class TorrentForm
    include ActiveModel::Model
    # ADD: Add in accessor to couple field will be use in the form
    attr_accessor :torrent_method, :email, :description, :error_message

    validates :email, :description, :error_message, presence: true
    validates :email, format: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, allow_blank: true

    # SPAM: Check to make sure this section isn't fill, if so, it might be a spam
    def spam?
      torrent_method.present?
    end
  end
end
