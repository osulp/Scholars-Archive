# frozen_string_literal:true

Rails.application.config.to_prepare do
  Hyrax::FileSetsController.class_eval do

    def show
      # Prevent fileset page from displaying if parent work is still in workflow
      if presenter.parent.solr_document.suppressed?
        flash[:notice] = "The item you tried to access is unavailable"
        redirect_to '/'
        return if presenter.parent.solr_document.suppressed?
      end
      # Original Hyrax response
      respond_to do |wants|
        wants.html { presenter }
        wants.json { presenter }
        additional_response_formats(wants)
      end
    end
  end
end
