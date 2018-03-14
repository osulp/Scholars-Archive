module ScholarsArchive
  class SharesController < Hyrax::My::SharesController
    include ScholarsArchive::MySharesBehavior
    before_action :custom_redirect, only: :index
  end
end
