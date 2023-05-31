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
    before_action :redirect_if_embargo, only: :show

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end

    def redirect_if_embargo
      curation_concern = ActiveFedora::Base.find(params[:id])
      return unless cannot?(:read, curation_concern) && curation_concern.embargo_id.present?

      flash[:notice] = 'Please contact us to request permission to access this page.'
      redirect_to Hyrax::Engine.routes.url_helpers.contact_path
    end
  end
end
