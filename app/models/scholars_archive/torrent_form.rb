# frozen_string_literal: true

module ScholarsArchive
  # CLASS: Torrent Form
  class TorrentForm
    include ActiveModel::Model
    # ADD: Add in accessor to couple field will be use in the form
    attr_accessor :email, :description, :error_message

    validates :email, :description, :error_message, presence: true
    validates :email, format: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, allow_blank: true
  end
end
