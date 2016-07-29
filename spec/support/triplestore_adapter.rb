ENV["RAILS_ENV"] ||= 'test'

TRIPLESTORE ||= TriplestoreAdapter::Triplestore.new(TriplestoreAdapter::Client.new(Settings.triplestore_adapter.type, Settings.triplestore_adapter.url))
TRIPLESTORE.client.provider.delete_namespace(ENV["RAILS_ENV"])
TRIPLESTORE.client.provider.build_namespace(ENV["RAILS_ENV"])

RSpec.configure do |config|
  config.before do
    TRIPLESTORE.delete_all_statements
  end
end