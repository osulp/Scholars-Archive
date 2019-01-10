# frozen_string_literal: true

module Parsers
  class DegreeFieldsParser
    def self.parse(jsonld)
      extract_and_massage_data(jsonld)
    end

    private

      def self.extract_and_massage_data(jsonld)
        graph = JSON.parse(jsonld).dig('@graph')
        return [{ id: 'invalid', term: 'invalid', active: true }] if graph.nil?
        terms = graph.map { |g| { id: g.dig('@id'), term: labels_with_dates(g), active: true } }
        # return only terms that have id and label
        terms.delete_if { |term| term[:id].nil? || term[:term].nil? }
      end

      def self.labels_with_dates(g)
        label = g.dig('rdfs:label', '@value')
        return label if label.nil?
        date = g.dig('dc:date')
        date = g.dig('dc:date', '@value') if date.is_a?(Hash)
        date = date.join(', ') if date.is_a?(Array)
        "#{label} - #{date}"
      end
  end
end
