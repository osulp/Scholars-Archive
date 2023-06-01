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
      # First we check if the user can see the work
      return unless cannot?(:read, curation_concern) && curation_concern.embargo_id.present?

      # Next we check if user got here specifically from the homepage. This means they got redirected and clicked the login link.
      return if request.original_url == 'http://ir.library.oregonstate.edu/'

      # Otherwise, this returns them to the homepage because they got here from elsewhere and need to know this work is embargoed
      # and if its OSU visible, provided a link to login and continue to where they were going
      case curation_concern.embargo.visibility_during_embargo
      when 'restricted'
        flash[:notice] = "The item you are trying to access is under embargo until #{curation_concern.embargo.embargo_release_date.month.strftime('%B')} #{curation_concern.embargo.embargo_release_date.day}, #{curation_concern.embargo.embargo_release_date.year}."
      when 'authenticated'
        flash[:notice] = "The item you are trying to access is under embargo until #{curation_concern.embargo.embargo_release_date.month.strftime('%B')} #{curation_concern.embargo.embargo_release_date.day}, #{curation_concern.embargo.embargo_release_date.year}. However, users with an OSU login (ONID) may log in to view the item. #{"<a href=#{request.original_url}> Click here to login and continue to your work </a>".html_safe}"
      end

      redirect_to '/'
    end
  end
end
