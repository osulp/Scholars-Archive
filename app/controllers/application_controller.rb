class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  # Adds Sufia behaviors into the application controller
  include Sufia::Controller

  include Hydra::Controller::ControllerBehavior
  layout 'sufia-one-column'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Any controller other than UsersController, redirect a user with an invalid
  # email address back to fix thier email
  before_action do |controller|
    if @current_user && controller.controller_name != 'users'
      if @current_user.has_default_email?
        flash[:error] = "Your email address is invalid, please update it."
        redirect_to sufia.edit_profile_path(@current_user)
      end
    end
  end
end
