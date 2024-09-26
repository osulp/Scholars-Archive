# frozen_string_literal: true

module ScholarsArchive
  module ControlledVocabularies
    # CLASS: Research Organization Registry (Controlled Vocab)
    class ResearchOrganizationRegistry < ActiveTriples::Resource
      include Hyrax::ControlledVocabularies::ResourceLabelCaching

      # METHOD: Setup custom rdf_label
      def rdf_label
        labels = Array.wrap(self.class.rdf_label)
        labels += default_labels
        # OVERRIDE: From rdf_triples to select only and all english labels
        values = []
        labels.each do |label|
          values += get_values(label).to_a
        end
        eng_values = values.select { |val| val.language.in? %i[en en-us] if val.is_a?(RDF::Literal) }

        # We want English first
        return eng_values unless eng_values.blank?

        # But we'll take non-english if that's all there is
        return values unless values.blank?

        node? ? [] : [rdf_subject.to_s]
      end

      # METHOD: To solrize and return a tuple of url & label
      def solrize
        return [rdf_subject.to_s] if rdf_label.first.to_s.blank? || rdf_label_uri_same?

        [rdf_subject.to_s, { label: "#{rdf_label}$#{rdf_subject}" }]
      end

      private

      # METHOD: Double check if rdf_label & subject are the same
      def rdf_label_uri_same?
        rdf_label.first.to_s == rdf_subject.to_s
      end
    end
  end
end
