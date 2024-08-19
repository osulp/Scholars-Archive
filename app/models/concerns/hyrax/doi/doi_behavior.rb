# frozen_string_literal: true

module Hyrax
  module DOI
    # Behavior for DOI on model
    module DOIBehavior
      extend ActiveSupport::Concern

      DOI_REGEX = %r(\A10\.\d{4,}(\.\d+)*\/[-._;():\/A-Za-z\d]+\z).freeze

      included do
        property :datacite_doi, predicate: ::RDF::Vocab::BIBO.doi, multiple: true do |index|
          index.as :stored_sortable
        end

        validate :validate_doi
      end

      # Override this method
      # Specify a registrar to use with this class
      def doi_registrar
        nil
      end

      # Override this method
      # Specify options for the registrar to use with this class
      def doi_registrar_opts
        {}
      end

      private

      # No need to add errors if its a drafted doi that will not be used. 
      def validate_doi
        Array(datacite_doi).each do |doi|
          next if doi_status_when_public == 'draft'

          errors.add(:datacite_doi, "DOI (#{doi}) is invalid.") unless doi.match? DOI_REGEX
        end
      end
    end
  end
end
