# This controller has actions for issuing a challenge page for CloudFlare Turnstile product,
# and then redirecting back to desired page.
#
# It also includes logic for configuring rack attack and a Rails controller filter to enforce
# redirection to these actions. All the logic related to bot detection with turnstile is
# mostly in this file -- with very flexible configuration in class_attributes -- to faciliate
# future extraction to a re-usable gem if desired.
#
# See more local docs at https://sciencehistory.atlassian.net/wiki/spaces/HDC/pages/2645098498/Cloudflare+Turnstile+bot+detection
#

require "http"

class BotDetectionController < ApplicationController
    # Config for bot detection is held here in class_attributes, kind of wonky, but it works
    #
    # These are defaults ready for extraction to a gem, in general here at Sci Hist if we want
    # to set config we do it in ./config/initializers/rack_attack.rb
  
    class_attribute :enabled, default: true # Must set to true to turn on at all
  
    class_attribute :cf_turnstile_sitekey, default: "1x00000000000000000000AA" # a testing key that always passes
    class_attribute :cf_turnstile_secret_key, default: "1x0000000000000000000000000000000AA" # a testing key always passes
    # Turnstile testing keys: https://developers.cloudflare.com/turnstile/troubleshooting/testing/
  
    # how long is a challenge pass good for before re-challenge?
    class_attribute :session_passed_good_for, default: 24.hours.ago
  
    # Executed at the _controller_ filter level, to last minute exempt certain
    # actions from protection.
    class_attribute :allow_exempt, default: ->(controller) { false }
  
    class_attribute :cf_turnstile_js_url, default: "https://challenges.cloudflare.com/turnstile/v0/api.js"
    class_attribute :cf_turnstile_validation_url, default:  "https://challenges.cloudflare.com/turnstile/v0/siteverify"
    class_attribute :cf_timeout, default: 3 # max timeout seconds waiting on Cloudfront Turnstile api
    helper_method :cf_turnstile_js_url, :cf_turnstile_sitekey
  
    # key stored in Rails session object with channge passed confirmed
    class_attribute :session_passed_key, default: "bot_detection-passed-2"
  
    # key in rack env that says challenge is required
    class_attribute :env_challenge_trigger_key, default: "bot_detect.should_challenge"
  
    # for allowing unsubscribe for testing
    class_attribute :_track_notification_subscription, instance_accessor: false
  
    # Usually in your ApplicationController,
    #
    #     before_action { |controller| BotDetectController.bot_detection_enforce_filter(controller) }
    def self.bot_detection_enforce_filter(controller)
      Rails.logger.info "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      Rails.logger.info controller.session[self.session_passed_key]
      Rails.logger.info controller.session[self.session_passed_key].try { |date| Time.new(date) < self.session_passed_good_for }
      if self.enabled && !controller.session[self.session_passed_key].try { |date| Time.new(date) < self.session_passed_good_for }
        # we can only do GET requests right now
        if !controller.request.get?
          Rails.logger.warn("#{self}: Asked to protect request we could not, unprotected: #{controller.requet.method} #{controller.request.url}, (#{controller.request.remote_ip}, #{controller.request.user_agent})")
          return
        end
  
        Rails.logger.info("#{self.name}: Cloudflare Turnstile challenge redirect: (#{controller.request.remote_ip}, #{controller.request.user_agent}): from #{controller.request.url}")
        # status code temporary
        controller.redirect_to '/challenge'
      end
    end
  
  
    def challenge
    end
  
    def verify_challenge
      body = {
        secret: self.cf_turnstile_secret_key,
        response: params["cf_turnstile_response"],
        remoteip: request.remote_ip
      }
  
      http = HTTP.timeout(self.cf_timeout)
      response = http.post(self.cf_turnstile_validation_url,
        json: body)
  
      result = response.parse
      Rails.logger.info result
      # {"success"=>true, "error-codes"=>[], "challenge_ts"=>"2025-01-06T17:44:28.544Z", "hostname"=>"example.com", "metadata"=>{"result_with_testing_key"=>true}}
      # {"success"=>false, "error-codes"=>["invalid-input-response"], "messages"=>[], "metadata"=>{"result_with_testing_key"=>true}}
  
      if result["success"]
        # mark it as succesful in session, and record time. They do need a session/cookies
        # to get through the challenge.
        session[self.session_passed_key] = Time.now.utc.iso8601
      else
        Rails.logger.warn("#{self.class.name}: Cloudflare Turnstile validation failed (#{request.remote_ip}, #{request.user_agent}): #{result}")
      end
  
      # let's just return the whole thing to client? Is there anything confidential there?
      render json: result
    rescue HTTP::Error, JSON::ParserError => e
      # probably an http timeout? or something weird.
      Rails.logger.warn("#{self.class.name}: Cloudflare turnstile validation error (#{request.remote_ip}, #{request.user_agent}): #{e}: #{response&.body}")
      render json: {
        success: false,
        http_exception: e
      }
    end
  end