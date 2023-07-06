# frozen_string_literal: true

# Controller for fileset, work, and other presenters
module Hyrax::Controller
  extend ActiveSupport::Concern
  include ScholarsArchive::RedirectIfRestrictedBehavior

  # OVERRIDE: Make an override to help with redirect for filesets
  included do
    self.search_state_class = Hyrax::SearchState

    # Adds Hydra behaviors into the application controller
    include Hydra::Controller::ControllerBehavior
    helper_method :create_work_presenter
    before_action :set_locale
  end

  # Provide a place for Devise to send the user to after signing in
  def user_root_path
    hyrax.dashboard_path
  end

  ##
  # @deprecated this helper is no longer used by Hyrax; if you need access to
  #   this presenter on every page, you may need to readd it manually.
  #
  # A presenter for selecting a work type to create this is needed here because
  # the selector is in the header on every page.
  def create_work_presenter
    Deprecation.warn(self, "The `create_work_presenter` helper is deprecated " \
                           "for removal in Hyrax 3.0. The work selector has " \
                           "been removed the masthead in Hyrax 2.1.")

    Hyrax::SelectTypeListPresenter.new(current_user)
  end

  # Ensure that the locale choice is persistent across requests
  def default_url_options
    super.merge(locale: I18n.locale)
  end

  private
  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # render a json response for +response_type+
  def render_json_response(response_type: :success, message: nil, options: {})
    json_body = Hyrax::API.generate_response_body(response_type: response_type, message: message, options: options)
    render json: json_body, status: response_type
  end

  # Called by Hydra::Controller::ControllerBehavior when CanCan::AccessDenied is caught
  # @param [CanCan::AccessDenied] exception error to handle
  def deny_access(exception)
    # For the JSON message, we don't want to display the default CanCan messages,
    # just custom Hydra messages such as "This item is under embargo.", etc.
    json_message = exception.message if exception.is_a? Hydra::AccessDenied
    if current_user&.persisted?
      deny_access_for_current_user(exception, json_message)
    else
      deny_access_for_anonymous_user(exception, json_message)
    end
  end

  def deny_access_for_current_user(exception, json_message)
    respond_to do |wants|
      wants.html do
        if [:show, :edit, :create, :update, :destroy].include? exception.action
          render 'hyrax/base/unauthorized', status: :unauthorized
        else
          redirect_to main_app.root_url, alert: exception.message
        end
      end
      wants.json { render_json_response(response_type: :forbidden, message: json_message) }
    end
  end

  def deny_access_for_anonymous_user(exception, json_message)
    session['user_return_to'.freeze] = request.url
    respond_to do |wants|
      wants.html { redirect_to main_app.root_url, alert: exception.message }
      wants.json { render_json_response(response_type: :unauthorized, message: json_message) }
    end
  end
end
