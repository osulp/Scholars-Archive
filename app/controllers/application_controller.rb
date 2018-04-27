class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController
  with_themed_layout '1_column'

  protect_from_forgery with: :exception

  # Hyrax 2.1 migration
  skip_after_action :discard_flash_if_xhr

  before_action :check_d2h_http_header_auth

  def check_d2h_http_header_auth
    if !user_signed_in? && request.headers.key?('HTTP_D2H_AUTHENTICATION')
      email, token = request.headers['HTTP_D2H_AUTHENTICATION'].split('|')
      if token === ENV['HTTP_D2H_AUTHENTICATION_TOKEN'] && email === ENV['HTTP_D2H_AUTHENTICATION_USERNAME']
        u = User.where(email: email).first
        sign_in :user, u
        redirect_to root_path
      else
        warden.custom_failure!
        render json: 'Unable to authenticate user.', status: 422
      end
    end
  end

  def default_url_options
    if Rails.env == "production"
      super.merge(protocol: :https) if Rails.env == 'production'
    else
      super
    end
  end

end
