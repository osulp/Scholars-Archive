# frozen_string_literal: true

# Application controller
class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  helper Hyrax::Engine.helpers
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController
  with_themed_layout '1_column'

  # Hyrax 2.1 migration
  skip_after_action :discard_flash_if_xhr

  protect_from_forgery with: :exception, unless: :http_header_auth?
  skip_before_action :verify_authenticity_token, unless: :http_header_auth?
  before_action :http_header_auth_login
  before_action :update_from_person_api
  # Check to see if we're in read_only mode
  before_action :check_read_only, except: [:show, :index]

  # What to do if read_only mode has been enabled, via FlipFlop
  # If read_only is enabled, redirect any requests that would allow
  # changes to the system. This is to enable easier migrations.
  def check_read_only
    return unless Flipflop.read_only?
    # Exempt the FlipFlop controller itself from read_only mode, so it can be turned off
    return if self.class.to_s == Hyrax::Admin::StrategiesController.to_s
    redirect_back(
      fallback_location: root_path,
      alert: "This system is in read-only mode for maintenance. No submissions or edits can be made at this time."
    )
  end

  ##
  # Attempt to query and update the current user information from the OSU directory
  # API. This helps to maintain details of the user type (student, employee, etc)
  # which can be leveraged to improve the usability for different types of users.
  def update_from_person_api
    if user_signed_in?
      begin
        current_user.update_from_person_api
      rescue
        # Don't fail hard when the API queries fail
        logger.error('Failed accessing OSU API, unable to synchronize user details.')
      end
    end
  end

  ##
  # Detect if the appropriate http header exists and if it has a username and token
  # to match the local_env.yml configuration. Used to bypass form token authentication
  # and to verify that the http request in question is providing legit credentials.
  def http_header_auth?
    return false unless request.headers.key?('HTTP_API_AUTHENTICATION')

    credentials = api_credentials(request.headers)
    credentials[:header][:token] == credentials[:config][:token] && credentials[:header][:username] == credentials[:config][:username]
  end

  ##
  # Bypass typical CAS authentication by querying the configured user and setting
  # it as authenticated. This allows for API requests to flow through without requiring
  # a CAS authentication to happen beforehand.
  def http_header_auth_login
    if !user_signed_in? && request.headers.key?('HTTP_API_AUTHENTICATION')
      credentials = api_credentials(request.headers)
      if http_header_auth?
        u = User.where(email: credentials[:config][:username]).first
        sign_in :user, u
        authenticate_user!
      else
        warden.custom_failure!
        render json: 'Unable to authenticate user.', status: 422
      end
    end
  end

  ##
  # Fetch the token and username from the local_env.yml (ENV) and from
  # the provided http header.
  # @param [HTTP::Headers] headers - the headers provided in this request
  # @return [Hash] - the header and configuration username and token values
  def api_credentials(headers)
    token = ENV.fetch('HTTP_API_AUTHENTICATION_TOKEN', nil)
    username = ENV.fetch('HTTP_API_AUTHENTICATION_USERNAME', nil)
    raise 'Invalid or missing configurations for HTTP API authentication' unless token && username

    {
      header: {
        username: headers['HTTP_API_AUTHENTICATION'].split('|')[0],
        token: headers['HTTP_API_AUTHENTICATION'].split('|')[1]
      },
      config: {
        username: username,
        token: token
      }
    }
  end

  ##
  # Force https for production
  def default_url_options
    if Rails.env == 'production'
      super.merge(protocol: :https) if Rails.env == 'production'
    else
      super
    end
  end

  if %w[production staging development].include? Rails.env
    def append_info_to_payload(payload)
      super(payload)
      Honeycomb.add_field('classname', self.class.name)
    end
  end
end
