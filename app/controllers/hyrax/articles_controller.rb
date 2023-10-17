# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Article`

module Hyrax
  # article controller
  class ArticlesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include ScholarsArchive::ArticlesControllerBehavior
    include ScholarsArchive::RedirectIfRestrictedBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = Article
    self.show_presenter = ArticlePresenter

    before_action :ensure_admin!, only: :destroy

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end
  end
end
