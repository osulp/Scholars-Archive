# frozen_string_literal: true

require 'linkeddata' # we need all the linked data types, because we don't know what types a service might return.
module ScholarsArchive
  # SA deep indexing service
  class SaDeepIndexingService < Hyrax::DeepIndexingService
    self.stored_fields = stored_fields - [:related_url]

    def fetch_values(value); end
  end
end
