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

    # rubocop:disable Metrics/MethodLength
    def render_unavailable
      parent_sd = unavailable_presenter.solr_document.parents.first
      @tombstoned = parent_sd.workflow_state == 'tombstoned'
      @presenter = "Hyrax::#{parent_sd["has_model_ssim"].first}Presenter".constantize.new(parent_sd, current_ability) if @tombstoned
      message = @tombstoned ? I18n.t('hyrax.workflow.tombstoned') : I18n.t('hyrax.workflow.unauthorized')
      respond_to do |wants|
        wants.html do
          flash[:notice] = message
          render 'unavailable', status: :unauthorized
        end
        wants.json do
          render plain: message, status: :unauthorized
        end
        additional_response_formats(wants)
        wants.ttl do
          render plain: message, status: :unauthorized
        end
        wants.jsonld do
          render plain: message, status: :unauthorized
        end
        wants.nt do
          render plain: message, status: :unauthorized
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
