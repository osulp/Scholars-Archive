# frozen_string_literal: true

module Hyrax
  module DOI
    module SolrDocument
      # Behavior for DOI on solr document
      module DOIBehavior
        extend ActiveSupport::Concern

        included do
          attribute :datacite_doi, ::SolrDocument::Solr::String, 'doi_ssi'
        end
      end
    end
  end
end
