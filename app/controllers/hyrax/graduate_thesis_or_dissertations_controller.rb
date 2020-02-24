# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`

module Hyrax
  # grad thesis or dissertation controller
  class GraduateThesisOrDissertationsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = GraduateThesisOrDissertation

    # Use this line if you want to use a custom presenter
    self.show_presenter = GraduateThesisOrDissertationPresenter

    # OVERRIDE FROM HYRAX TO INSERT SOLR DOCUMENT INTO DOCUMENT LIST IF THE WORK WAS INGESTED BY THE CURRENT USER
    def search_result_document(search_params)
      _, document_list = search_results(search_params)
      solr_doc = ::SolrDocument.find(params[:id])
      document_list << solr_doc if solr_doc.depositor == current_user.username
      return document_list.first unless document_list.empty?
      document_not_found!
    end

    before_action :ensure_admin!, only: :destroy

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end
  end
end
