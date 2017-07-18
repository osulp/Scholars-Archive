module Parsers
  class AcademicUnitsParser
    def self.parse(jsonld)
      extract_and_massage_data(jsonld)
    end

    private

      def self.extract_and_massage_data(jsonld)
        graph = JSON.parse(jsonld).dig("@graph")
        return [{ id: "invalid", term: "invalid", active: true }] if graph.nil?
        terms = graph.map { |g| { id: g.dig("@id"), term: g.dig("rdfs:label", "@value"), active: true } }
        # return only terms that have id and label
        terms.delete_if { |term| term[:id].nil? || term[:term].nil? }
      end
  end
end
