# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Dataset`

module Hyrax
  # dataset controller
  class DatasetsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include ScholarsArchive::DatasetsControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = Dataset

    # Use this line if you want to use a custom presenter
    self.show_presenter = DatasetPresenter

    before_action :ensure_admin!, only: :destroy

    def new
      # The first view path is hyrax_doi, overriding our overrides. The third is also hyrax_doi, so we still get their views
      view_context.view_paths = view_paths.drop(1)
      super
    end

    def edit
      # The first view path is hyrax_doi, overriding our overrides. The third is also hyrax_doi, so we still get their views
      view_context.view_paths = view_paths.drop(1)
      super
    end

    def update
      # The first view path is hyrax_doi, overriding our overrides. The third is also hyrax_doi, so we still get their views
      view_context.view_paths = view_paths.drop(1)
      super
    end

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end
  end
end
