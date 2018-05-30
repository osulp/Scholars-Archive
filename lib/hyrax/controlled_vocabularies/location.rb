module Hyrax
  module ControlledVocabularies
    class Location < ActiveTriples::Resource
      configure rdf_label: ::RDF::Vocab::GEONAMES.name

      property :parentFeature, :predicate => RDF::URI('http://www.geonames.org/ontology#parentFeature'), :class_name => 'Hyrax::ControlledVocabularies::Location'
      property :parentCountry, :predicate => RDF::URI('http://www.geonames.org/ontology#parentCountry'), :class_name => 'Hyrax::ControlledVocabularies::Location'
      property :featureCode, :predicate => RDF::URI('http://www.geonames.org/ontology#featureCode')
      property :featureClass, :predicate => RDF::URI('http://www.geonames.org/ontology#featureClass')


      # Return a tuple of url & label
      def solrize
        return [rdf_subject.to_s] if rdf_label.first.to_s.blank? || rdf_label.first.to_s == rdf_subject.to_s
        [rdf_subject.to_s, { label: "#{rdf_label.first}$#{rdf_subject}" }]
      end

      # Overrides rdf_label to recursively add location disambiguation when available.
      def rdf_label
        label = super
        unless parentFeature.empty? or RDF::URI(label.first).valid?
          #TODO: Identify more featureCodes that should cause us to terminate the sequence
          return "#{label}" if top_level_element?
          parent_label = (parentFeature.first.kind_of? ActiveTriples::Resource) ? parentFeature.first.rdf_label.first : []
          fc_label = (featureClass.first.kind_of? ActiveTriples::Resource) ? featureClass.first.rdf_label.first : []

          return label if parent_label.empty? or RDF::URI(parent_label).valid? or parent_label.starts_with? '_:'
          # return label if fc_label.empty? or RDF::URI(fc_label).valid?
          label = "#{label.first} , #{parent_label}  (#{fc_label})"
        end
        Array(label)
      end

      # Fetch parent features if they exist. Necessary for automatic population of rdf label.
      def fetch(headers)
        result = super(headers)
        return result if top_level_element?
        parentFeature.each do |feature|
          feature.fetch(headers)
        end
        featureClass.each do |fc|
          fc.fetch(headers)
        end
        result
      end

      # Persist parent features.
      def persist!
        result = super
        return result if top_level_element?
        parentFeature.each do |feature|
          feature.persist!
        end
        featureClass.each do |fc|
          fc.persist!
        end
        result
      end

      def top_level_element?
        featureCode = self.featureCode.first
        top_level_codes = [RDF::URI('http://www.geonames.org/ontology#A.PCLI')]
        featureCode.respond_to?(:rdf_subject) && top_level_codes.include?(featureCode.rdf_subject)
      end
    end
  end
end
