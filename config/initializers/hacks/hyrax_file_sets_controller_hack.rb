# frozen_string_literal:true

Rails.application.config.to_prepare do
  Hyrax::FileSetsController.class_eval do
    # INCLUDE: Add in the redirect to filesets for embargo
    include ScholarsArchive::RedirectIfRestrictedBehavior

    def show
      # Prevent fileset page from displaying if parent work is still in workflow
      if presenter.parent.solr_document.suppressed? && !current_user&.admin?
        flash[:notice] = "The item you tried to access is unavailable because it is in the review process."
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
