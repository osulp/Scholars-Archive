# frozen_string_literal: true

module ScholarsArchive
  module ControlledVocabularies
    # CLASS: AcademicAffiliation (Controlled Vocab)
    class AcademicAffiliation < ActiveTriples::Resource
      include Hyrax::ControlledVocabularies::ResourceLabelCaching

      # METHOD: Create custom rdf_label fetch
      def rdf_label
        labels = Array.wrap(self.class.rdf_label)
        labels += default_labels

        # OVERRIDE: From rdf_triples to select labels
        values = []
        labels.each do |label|
          values += get_values(label).to_a
        end

        return values unless values.empty?

        node? ? [] : [rdf_subject.to_s]
      end

      # METHOD: Add in full label fetch for the edit work page
      def full_label
        ScholarsArchive::AcademicAffiliationService.new.full_label(rdf_subject.to_s)
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
    end
  end
end
