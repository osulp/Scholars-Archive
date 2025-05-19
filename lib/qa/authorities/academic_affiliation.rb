# frozen_string_literal: true

module Qa::Authorities
  # CLASS: Academic Affiliation
  class AcademicAffiliation < Qa::Authorities::Base
    include WebServiceBase

    # ATTRIBUTE: Add a :label class attribute
    class_attribute :label

    # SELF METHOD: Format the label to present on typeahead
    self.label = lambda do |item|
      "#{item['rdfs:label']['@value']} - #{item['dc:date']}, (#{item['@id']})"
    end

    # METHOD: Create a search function based on user typing
    def search(query)
      # CONDITION: Check if user search by 'http', or 'word'
      if query.match(%r{^https?://opaquenamespace.org/ns/osuAcademicUnits/})
        parse_authority_response_with_id(json("#{query}.jsonld"))
      else
        parse_authority_response(json(build_query_url), query)
      end
    end

    # METHOD: Build search using 'word'
    def build_query_url
      'https://opaquenamespace.org/ns/osuAcademicUnits.jsonld'
    end

    # METHOD: Override the find method ID for full label
    def find(id)
      json("https://opaquenamespace.org/ns/osuAcademicUnits/#{id}.jsonld")
    end

    private

    # PARSE: Reformats the data received from the service
    def parse_authority_response(response, query)
      parse_array = []

      response['@graph'].select do |result|
        parse_array << { 'id' => result['@id'].to_s, 'label' => label.call(result) } if result.key?('rdfs:label') && result['rdfs:label']['@value'].downcase.include?(query.downcase)
      end.compact

      parse_array
    end

    # REFORMAT: Format data with the id given or HTTP
    def parse_authority_response_with_id(response)
      [{ 'id' => response['@id'].to_s,
         'label' => label.call(response) }]
    end
  end
end
