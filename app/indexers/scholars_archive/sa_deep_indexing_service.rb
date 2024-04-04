# frozen_string_literal: true

require 'linkeddata' # we need all the linked data types, because we don't know what types a service might return.
module ScholarsArchive
  # SA deep indexing service
  class SaDeepIndexingService < Hyrax::DeepIndexingService
    self.stored_fields = stored_fields - %i[access_right related_url rights_notes]

    private

    # OVERRIDEN FROM HYRAX TO BYPASS THE FETCHING OF CONTROLLED VOCABULARIES
    def fetch_value(value); end
  end
end
