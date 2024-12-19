# frozen_string_literal: true

module Qa::Authorities
  # Geonames authority
  class Geonames < Base
    include WebServiceBase

    class_attribute :username, :label

    class << self
      private

      def translate_fcl(fcl)
        { 'A' => 'Administrative Boundary',
          'H' => 'Hydrographic',
          'L' => 'Area',
          'P' => 'Populated Place',
          'R' => 'Road / Railroad',
          'S' => 'Spot',
          'T' => 'Hypsographic',
          'U' => 'Undersea',
          'V' => 'Vegetation' }[fcl]
      end
    end

    self.label = lambda do |item|
      translated_fcl = translate_fcl(item['fcl'])
      [item['name'], item['adminName1'], item['countryName'], "(#{translated_fcl})"].compact.join(', ')
    end

    def search(q)
      unless username
        Rails.logger.error 'Questioning Authority tried to call geonames, but no username was set'
        return []
      end

      # CHECK: Making a check that if an id number or url is enter instead of city name
      if q.to_s.match(/^[0-9]*$/)
        parse_response_with_id(json(build_id_url(q)))
      elsif q.to_s.match(%r{^https?://www\.geonames\.org})
        # PARSE: Get the id out of the URL & fetch the id to be use for
        query = URI(q.to_s).path.split('/')[1]
        parse_response_with_id(json(build_id_url(query)))
      else
        parse_authority_response(json(build_query_url(q)))
      end
    end

    # BUILD: Create a search using id number instead
    def build_id_url(q)
      query = CGI.escape(untaint(q))
      "http://api.geonames.org/getJSON?geonameId=#{query}&username=#{username}"
    end

    def build_query_url(q)
      query = CGI.escape(untaint(q))
      "http://api.geonames.org/searchJSON?q=#{query}&username=#{username}&maxRows=10"
    end

    def untaint(q)
      q.gsub(/[^\w\s-]/, '')
    end

    def find(id)
      json(find_url(id))
    end

    def find_url(id)
      "http://www.geonames.org/getJSON?geonameId=#{id}&username=#{username}"
    end

    private

    # Reformats the data received from the service
    def parse_authority_response(response)
      response['geonames'].map do |result|
        # NOTE: the trailing slash is meaningful.
        { 'id' => "https://sws.geonames.org/#{result['geonameId']}/",
          'label' => label.call(result) }
      end
    end

    # REFORMAT: Format data with the id given
    def parse_response_with_id(response)
      # NOTE: the trailing slash is meaningful.
      [{ 'id' => "https://sws.geonames.org/#{response['geonameId']}/",
         'label' => label.call(response) }]
    end
  end
end
