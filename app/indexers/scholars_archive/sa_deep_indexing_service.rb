require 'linkeddata' # we need all the linked data types, because we don't know what types a service might return.
module ScholarsArchive
  class SaDeepIndexingService < Hyrax::DeepIndexingService
    self.stored_fields = stored_fields - [:related_url]

    private
    def fetch_external
      object.controlled_properties.each do |property|
        object[property].each do |value|
          resource = value.respond_to?(:resource) ? value.resource : value
          next unless resource.is_a?(ActiveTriples::Resource)
          next if value.is_a?(ActiveFedora::Base)
          fetch_with_persistence(resource)
        end
      end
    end
    def fetch_with_persistence(resource)
      old_label = resource.rdf_label.first
      return unless old_label == resource.rdf_subject.to_s || old_label.nil?
      fetch_value(resource)
      return if old_label == resource.rdf_label.first || resource.rdf_label.first == resource.rdf_subject.to_s
      resource.persist! # Stores the fetched values into our marmotta triplestore
    end
  end
end
