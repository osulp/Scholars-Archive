# frozen_string_literal: true

require 'http'

# This controller has actions for issuing a challenge page for CloudFlare Turnstile product,
# and then redirecting back to desired page.
class BotDetectionController < ApplicationController
  # Cloudflare public "always passes" testing key.
  CF_TURNSTILE_TESTING_SECRET_KEY = '1x0000000000000000000000000000000AA'
  CF_TURNSTILE_TESTING_SITE_KEY = '1x00000000000000000000AA'

  SESSION_PASSED_GOOD_FOR = 24.hours

  class_attribute :enabled, default: ENV.fetch('CF_ENABLED', false) # Must set to true to turn on at all

  class_attribute :cf_turnstile_sitekey, default: ENV.fetch('CF_TURNSTILE_SITE_KEY', CF_TURNSTILE_TESTING_SITE_KEY) # a testing key that always passes
  class_attribute :cf_turnstile_secret_key, default: ENV.fetch('CF_TURNSTILE_SECRET_KEY', CF_TURNSTILE_TESTING_SECRET_KEY) # a testing key always passes
  class_attribute :cf_turnstile_js_url, default: ENV.fetch('CF_TURNSTILE_JS_URL', 'https://challenges.cloudflare.com/turnstile/v0/api.js')
  class_attribute :cf_turnstile_validation_url, default: ENV.fetch('CF_TURNSTILE_VALIDATION_URL', 'https://challenges.cloudflare.com/turnstile/v0/siteverify')
  class_attribute :cf_timeout, default: ENV.fetch('CF_TIMEOUT', 3) # max timeout seconds waiting on Cloudfront Turnstile api
  helper_method :cf_turnstile_js_url, :cf_turnstile_sitekey

  # key stored in Rails session object with change passed confirmed
  class_attribute :session_passed_key, default: 'bot_detection-passed'

  def self.bot_detection_enforce_filter(controller)
    return unless enabled.to_s == 'true' && session_expired?(controller.session)

    return unless controller.request.get?

    Rails.logger.info 'Redirecting for Turnstile'
    controller.redirect_to "/challenge?dest=#{controller.request.original_fullpath}", status: 307
  end

  def self.session_expired?(session)
    passed_at = session[session_passed_key]
    return true if passed_at.blank?

    Time.parse(passed_at) < Time.now - SESSION_PASSED_GOOD_FOR
  rescue StandardError
    true
  end

  def challenge
    @dest = request.query_parameters.delete('dest').to_s
    @dest += "&#{request.query_parameters.to_query}" unless request.query_parameters.to_query.empty?
    @dest = CGI.unescape(@dest)
  end

  # rubocop:disable Metrics/MethodLength
  def verify_challenge
    body = { secret: cf_turnstile_secret_key, response: params['cf_turnstile_response'], remoteip: request.remote_ip }
    response = HTTP.timeout(cf_timeout.to_i).post(cf_turnstile_validation_url, json: body)
    result = response.parse

    Rails.logger.info "Turnstile redirect result: #{result}"

    if result['success']
      session[session_passed_key] = Time.now.utc.iso8601
    else
      Rails.logger.warn("Cloudflare Turnstile validation failed (#{request.remote_ip}, #{request.user_agent}): #{result}")
      redirect_to '/contact'
    end

    render json: result
  rescue HTTP::Error, JSON::ParserError => e
    Rails.logger.warn("Cloudflare turnstile validation error (#{request.remote_ip}, #{request.user_agent}): #{e}: #{response&.body}")
    redirect_to '/contact'
  end
  # rubocop:enable Metrics/MethodLength
end
