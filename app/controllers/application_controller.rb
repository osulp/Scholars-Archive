class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
  include Blacklight::Controller  
# Adds Sufia behaviors into the application controller 
  include Sufia::Controller

  include Hydra::Controller::ControllerBehavior
  layout 'sufia-one-column'

  # after_filter do
  #   if response.headers['Content-Length'].present?
  #     response.headers['Content-Length'] = response.headers['Content-Length'].to_s
  #   end
  # end
  #
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

end
