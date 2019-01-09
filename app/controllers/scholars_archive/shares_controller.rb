# frozen_string_literal: true

module ScholarsArchive
  # shares controller
  class SharesController < Hyrax::My::SharesController
    include ScholarsArchive::MySharesBehavior
    before_action :custom_redirect, only: :index
  end
end
