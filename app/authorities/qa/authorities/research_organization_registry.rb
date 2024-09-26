# frozen_string_literal: true

module Qa::Authorities
  # CLASS: Research Organization Registry
  class ResearchOrganizationRegistry < Qa::Authorities::Base
    include WebServiceBase

    # ATTRIBUTE: Add a :label class attribute
    class_attribute :label

    # SELF METHOD: Format the label to present on typeahead
    self.label = lambda do |item|
      [item['names'].map { |v| v['value'] if v['types'].include?('ror_display') }, "(#{item['id']})"].compact.join(', ')
    end

    # METHOD: Create a search function based on user typing
    def search(query)
      # CONDITION: Check if user search by 'id' or 'word'
      if query[0] == '0' && query.length == 9
        parse_authority_response_with_id(json(build_id_url(query)))
      else
        parse_authority_response(json(build_query_url(query)))
      end
    end

    # METHOD: To double check the 'q' string for special char
    def untaint(query)
      query.gsub(/[^\w\s-]/, '')
    end

    # METHOD: Build search using 'word'
    def build_query_url(query)
      query_str = URI.escape(untaint(query))
      "https://api.ror.org/v2/organizations?query=#{query_str}"
    end

    # METHOD: Create a search using id number instead
    def build_id_url(query)
      query_str = URI.escape(untaint(query))
      "https://api.ror.org/v2/organizations/#{query_str}"
    end

    private

    # PARSE: Reformats the data received from the service
    def parse_authority_response(response)
      response['items'].map do |result|
        { 'id' => result['id'].to_s,
          'label' => label.call(result) }
      end
    end

    # REFORMAT: Format data with the id given
    def parse_authority_response_with_id(response)
      [{ 'id' => response['id'].to_s,
         'label' => label.call(response) }]
    end
  end
end
