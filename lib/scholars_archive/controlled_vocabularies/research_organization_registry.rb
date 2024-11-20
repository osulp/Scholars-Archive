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
      # rubocop:disable Security/Open
      def fetch_graph_manual
        # GRAB: Fetch and modify the URL from rdf_subject
        modify_url = rdf_subject.to_s.split('/')
        modify_url[1] = '//api.ror.org'
        modify_url[2] = '/v2/organizations/'
        url = modify_url.join

        # GRAB: Fetch and parse the raw JSON data from the URL
        json_data = URI.open(url).read
        parsed_data = JSON.parse(json_data)

        # GRAPH: Define a new RDF::Graph
        graph = RDF::Graph.new

        # GET: Get the value for RDF::Literal
        val_literal = parsed_data['names'].map { |v| v['value'] if v['types'].include?('ror_display') }

        # INGEST: Add in "subject", "predicate", and "object" keys
        subject = RDF::URI(rdf_subject.to_s)
        predicate = RDF::URI("#{rdf_subject}/item/test")
        object = RDF::Literal.new(val_literal.join)

        # INSERT: Insert the RDF triple into the graph & return graph
        graph << [subject, predicate, object]
        graph
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Security/Open
    end
  end
end
