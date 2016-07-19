# build the namespace if it doesn't already exist. Test needs to manage this
# itself so that WebMock allows for the HTTP calls, and Production is sensitive
# and shouldn't be automatically built.
unless Rails.env.downcase == 'test' || Rails.env.downcase == 'production'
  triplestore_client = TriplestoreAdapter::Client.new(Settings.triplestore_adapter.type, Settings.triplestore_adapter.url)
  triplestore = TriplestoreAdapter::Triplestore.new(triplestore_client)
  triplestore.client.provider.build_namespace(Rails.env.downcase)
end