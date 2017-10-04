class OaiSet < BlacklightOaiProvider::Set
#  class Set
    class << self
      # The Solr repository object (optional)
      attr_accessor :repository

      # The search builder used to construct OAI queries (optional)
      attr_accessor :search_builder

      # The Solr fields to map to OAI sets. Must be indexed (optional)
      attr_accessor :fields

      # Return an array of all sets, or nil if sets are not supported
      def all
        return if @fields.nil?

        params = { rows: 0, facet: true, 'facet.field' => @fields }
        response = @repository.search @search_builder.merge(params)
        sets_from_facets(response.facet_fields) if response.facet_fields
      end

      # Return a Solr filter query given a set spec
      def from_spec(spec)
        parts = spec.split(':')
        raise OAI::ArgumentException unless parts.count == 2 && Array(@fields).include?(parts[0])
        parts.join(':')
      end

      private

      def sets_from_facets(facets)
        sets = []
        facets.each do |facet, terms|
          sets.concat terms.each_slice(2).map { |t| new("#{facet}:#{t.first}") }
        end
        sets.empty? ? nil : sets
      end
    end

    # OAI Set properties
    attr_accessor :spec, :name, :description

    # Build a set object with, at minimum, a set spec string
    def initialize(spec, opts = {})
      @spec = spec
      @name = opts[:name] || name_from_spec
      @description = opts[:description]
    end

    private

    def name_from_spec
      @spec.split(':').last.titleize
    end
#  end
end
