# frozen_string_literal: true

require 'triplestore_adapter'

module ScholarsArchive
  # Triple powered
  class TriplePoweredService
    def fetch_all_labels(uris)
      labels = []
      uris.each do |uri|
        graph = fetch_from_store(uri)
        labels << predicate_labels(graph).values.flatten.compact.collect { |label| "#{label}$#{uri.to_s}" }
      end
      labels.flatten.compact
    end

    def fetch_all_labels_with_date(uris)
      labels = []
      uris.each do |uri|
        graph = fetch_from_store(uri)
        values = predicate_label_dates(graph).values.flatten.compact
        labels << if values.size > 0
                    values.collect { |label_date| "#{label_date}$#{uri.to_s}" }
                  else
                    predicate_labels(graph).values.flatten.compact.collect { |label| "#{label}$#{uri.to_s}" }
                  end
      end
      labels.flatten.compact
    end

    def fetch_top_label(uris, parse_date: false)
      if parse_date
        fetch_all_labels_with_date(uris).first
      else
        fetch_all_labels(uris).first
      end
    end

    private

    def predicate_label_dates(graph)
      label_dates = {}
      return label_dates if graph.nil?

      rdf_label_predicates.each do |predicate|
        label_dates[predicate.to_s] = []
        label_dates[predicate.to_s] << label_dates_query(graph, predicate)
          .select { |statement| !statement.is_a?(Array) }
          .map { |statement| "#{statement.label.to_s} - #{statement.date.to_s}" }
        label_dates[predicate.to_s].flatten!.compact!
      end
      label_dates
    end

    def label_dates_query(graph, label_predicate)
      patterns = {
        label_date: {
          label_predicate => :label,
          RDF::Vocab::DC.date => :date
        }
      }
      query = RDF::Query.new(patterns)
      query.execute(graph).to_a
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def predicate_labels(graph)
      labels = {}
      return labels if graph.nil?
      rdf_label_predicates.each do |predicate|
        eng_labels = graph
          .query(predicate: predicate)
          .select { |statement| !statement.is_a?(Array) }
          .map(&:object)
          .select { |value| value }
        labels[predicate.to_s] = []
        labels[predicate.to_s] << eng_labels.map(&:to_s)
        labels[predicate.to_s].flatten!.compact!
      end
      labels
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def rdf_label_predicates
      [
        RDF::Vocab::SKOS.prefLabel,
        RDF::Vocab::DC.title,
        RDF::RDFS.label,
        RDF::Vocab::SKOS.altLabel,
        RDF::Vocab::SKOS.hiddenLabel
      ]
    end

    def fetch_from_store(uri)
      unless uri.blank?
        begin
          @triplestore ||= TriplestoreAdapter::Triplestore.new(TriplestoreAdapter::Client.new(ENV['SCHOLARSARCHIVE_TRIPLESTORE_ADAPTER_TYPE'] || 'blazegraph',
                                                                                              ENV['SCHOLARSARCHIVE_TRIPLESTORE_ADAPTER_URL'] || 'http://localhost:9999/blazegraph/namespace/development/sparql'))
          @triplestore.fetch(uri, from_remote: true)
        rescue TriplestoreAdapter::TriplestoreException => e
          Rails.logger.warn e.message
          nil
        end
      end
    end
  end
end
