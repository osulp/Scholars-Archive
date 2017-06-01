# Generated via
#  `rails generate hyrax:work Article`

module Hyrax
  class ArticlesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = Article
    self.show_presenter = ArticlePresenter
  end
end
