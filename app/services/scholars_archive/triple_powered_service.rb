module ScholarsArchive
  class TriplePoweredService
    def fetch(uris)
      labels = []
      uris.each do |uri|
        graph = ScholarsArchive::TriplePoweredProperties::Triplestore.fetch(uri)
        labels << ScholarsArchive::TriplePoweredProperties::Triplestore.predicate_labels(graph).values.flatten.compact.collect{ |label| label + "$" + uri.to_s }
      end
      labels.flatten.compact
    end
  end
end
