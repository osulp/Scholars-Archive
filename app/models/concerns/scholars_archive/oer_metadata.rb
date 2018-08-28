module ScholarsArchive
  module OerMetadata
    extend ActiveSupport::Concern

    # Usage notes and expectations can be found in the Metadata Application Profile:
    #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

    included do
      property :interactivity_type, predicate: ::RDF::Vocab::LRMI.interactivityType do |index|
        index.as :stored_searchable
      end

      property :is_based_on_url, predicate: ::RDF::Vocab::LRMI.isBasedOnUrl do |index|
        index.as :stored_searchable
      end

      property :learning_resource_type, predicate: ::RDF::Vocab::LRMI.learningResourceType do |index|
        index.as :stored_searchable
      end

      property :time_required, predicate: ::RDF::Vocab::LRMI.timeRequired do |index|
        index.as :stored_searchable
      end

      property :nested_ordered_typical_age_range, predicate: ::RDF::Vocab::LRMI.typicalAgeRange do |index|
        index.as :stored_searchable
      end

      property :duration, predicate: ::RDF::Vocab::MA.duration do |index|
        index.as :stored_searchable
      end

      accepts_nested_attributes_for :nested_ordered_typical_age_range, :allow_destroy => true, :reject_if => proc { |attributes| attributes[:index].blank? || attributes[:typical_age_range].blank? || attributes.all? { |key, value| key == "_destroy" || value.blank? } }
    end
  end
end
