# frozen_string_literal: true

module ScholarsArchive
  module ControlledVocabularies
    # CLASS: Research Organization Registry (Controlled Vocab)
    class ResearchOrganizationRegistry < ActiveTriples::Resource
      include Hyrax::ControlledVocabularies::ResourceLabelCaching

      # METHOD: Create custom rdf_label fetch
      # rubocop:disable Metrics/MethodLength
      def rdf_label
        labels = Array.wrap(self.class.rdf_label)
        labels += default_labels

        # OVERRIDE: From rdf_triples to select labels
        values = []
        labels.each do |label|
          values += get_values(label).to_a
        end

        # CONDITION: If values is blank, then we fetch out from objects to get the label
        if values.blank?
          ror_labels = []
          ror_labels << objects.first.to_s unless objects.blank?
          return ror_labels
        end

        node? ? [] : [rdf_subject.to_s]
      end
      # rubocop:enable Metrics/MethodLength

      # METHOD: Add in full label fetch for the edit work page
      def full_label
        ScholarsArchive::ResearchOrganizationRegistryService.new.full_label(rdf_subject.to_s)
      end

      # METHOD: Override fetch to do a manual fetch on ROR
      def fetch(*_args, &_block)
        persistence_strategy.graph = fetch_graph_manual
      end

      # METHOD: To solrize and return a tuple of url & label
      def solrize
        return [rdf_subject.to_s] if rdf_label.first.to_s.blank? || rdf_label_uri_same?

        [rdf_subject.to_s, { label: "#{rdf_label.first}$#{rdf_subject}" }]
      end

      private

      # METHOD: Double check if rdf_label & subject are the same
      def rdf_label_uri_same?
        rdf_label.first.to_s == rdf_subject.to_s
      end

      # METHOD: Add in a manual fetch for graph
      def fetch_graph_manual
        # BUILD: Build the URL to fetch JSON data from it
        url = URI::HTTP.build(host: 'api.ror.org', path: "/v2/organizations/#{rdf_subject.to_s.split('/').last}")

        # GET: Get the value for RDF::Literal
        val_literal = JSON.parse(url.open.read)['names'].map { |v| v['value'] if v['types'].include?('ror_display') }

        # INSERT: Insert the RDF triple into the graph & return graph
        RDF::Graph.new << [RDF::URI(rdf_subject.to_s), ::RDF::Vocab::MARCRelators.fnd, RDF::Literal.new(val_literal.join)]
      end
    end
  end
end
