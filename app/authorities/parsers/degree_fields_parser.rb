# frozen_string_literal: true

module Parsers
  # parses degree fields
  class DegreeFieldsParser
    def self.parse(jsonld)
      extract_and_massage_data(jsonld)
    end

    private

      def self.extract_and_massage_data(jsonld)
        graph = JSON.parse(jsonld).dig('@graph')
        return [{ id: 'invalid', term: 'invalid', active: true }] if graph.nil?

        terms = graph.map { |g| { id: g.dig('@id'), term: labels_with_dates(g), active: true } unless deprecated?(g) }.compact
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

      def self.deprecated?(g)
        # return true if value is in isReplacedBy
        g.dig('dc:isReplacedBy')
      end
  end
end
