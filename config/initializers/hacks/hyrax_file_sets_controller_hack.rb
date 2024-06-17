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
