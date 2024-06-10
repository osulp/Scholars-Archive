# frozen_string_literal:true

Hyrax::FileSetsController.class_eval do
  include ScholarsArchive::RedirectIfRestrictedBehavior
    
  prepend_before_action :redirect_if_unavailable, only: :show
  prepend_before_action :redirect_if_restricted, only: :show

  def redirect_if_unavailable
    # Prevent fileset page from displaying if parent work is still in workflow
    if presenter.parent.solr_document.suppressed? && !current_user&.admin?
      flash[:notice] = "The item you tried to access is unavailable because it is in the review process."
      redirect_to '/'
      return if presenter.parent.solr_document.suppressed?
    end
  end
end
