# frozen_string_literal: true

module Hyrax
  module DOI
    # DOI behavior for Presenter
    module DOIPresenterBehavior
      extend ActiveSupport::Concern

      def doi
        solr_document.datacite_doi.present? ? "https://doi.org/#{solr_document.datacite_doi}" : nil
      end
    end
  end
end
