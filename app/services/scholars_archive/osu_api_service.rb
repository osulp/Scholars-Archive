# frozen_string_literal: true

require 'faraday'
require 'json'

module ScholarsArchive
  # OSU Api
  class OsuApiService
    attr_accessor :token, :logger, :people

    def initialize(logger = nil)
      @logger = logger || Logger.new(STDOUT)
      @people = {}
      @token = get_token
    end

    def get_person(onid)
      return @people[onid] if @people[onid]

      url = "#{ENV['OSU_API_HOST']}/v1/directory"
      params = { q: onid }
      header = authorization_header
      @logger.debug("OsuApiService#get_person : fetching user : #{url} with params #{params}")
      response = get(url, params, header)
      @logger.debug('OsuApiService#get_person : returned user') if response.status == 200
      @logger.error("OsuApiService#get_person(#{onid}) failed : #{response.status} : #{response.reason_phrase}") unless response.status == 200
      if response.status == 200
        o = JSON.parse(response.body)
        @people[onid] = o['data'].first
        @people[onid]
      else
        nil
      end
    end

    private

    def get(url, params, headers = {})
      Faraday.get url, params, headers
    end

    def post(url, params, headers = {})
      Faraday.post url, params, headers
    end

    def get_token
      url = "#{ENV['OSU_API_HOST']}/oauth2/token"
      @logger.debug("OsuApiService#get_token : fetching token : #{url}")
      response = post(url, { grant_type: 'client_credentials', client_id: ENV['OSU_API_CLIENT_ID'], client_secret: ENV['OSU_API_CLIENT_SECRET'] })
      @logger.error("OsuApiService#get_token failed : #{response.status} : #{response.reason_phrase}") unless response.status == 200
      if response.status == 200
        json = JSON.parse(response.body)
        json['access_token']
      else
        raise 'OsuApiService#get_token failed: #{response.status} : #{response.reason_phrase}'
      end
    end

    def authorization_header
      { 'Authorization' => "Bearer #{@token}" }
    end
  end
end
